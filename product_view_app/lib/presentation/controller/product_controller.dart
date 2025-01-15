import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_view_app/presentation/model/product_model.dart';

class ProductController {
  static final ProductController _instance = ProductController._internal();

  List<ProductModel> listProducts = const [];

  factory ProductController() {
    return _instance;
  }

  ProductController._internal();

  Future<void> getProducts(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse("http://103.45.234.81:5000/api/product"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<ProductModel> products =
            jsonData.map((json) => ProductModel.fromJson(json)).toList();
        listProducts = products;
      } else {
        listProducts = [];
      }
    } catch (e) {
      listProducts = [];
    }
  }

  Future<bool> commentProduct(
      String accessToken, int productId, String comments) async {
    String body = jsonEncode({
      "Comment": comments,
    });
    int contentLength = body.length;
    try {
      final response = await http.post(
        Uri.parse("http://103.45.234.81:5000/api/product/$productId/comment"),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Content-Length': contentLength.toString(),
        },
        body: body,
      );
      if (response.statusCode == 200) {
        await getProducts(accessToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
