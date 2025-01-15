import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_view_app/presentation/model/login_model.dart';

class LoginController {
  static final LoginController _instance = LoginController._internal();

  LoginModel modelData = const LoginModel(
    accessToken: "",
    userId: -1,
    isAdmin: false,
    status: 401,
  );

  factory LoginController() {
    return _instance;
  }

  LoginController._internal();

  Future<void> login(String username, String password) async {
    String body = jsonEncode({
      "username": username,
      "password": password,
    });
    int contentLength = body.length;
    try {
      final response = await http.post(
        Uri.parse("http://103.45.234.81:5000/api/auth/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Content-Length': contentLength.toString(),
        },
        body: body,
      );

      if (response.statusCode == 200) {
        modelData = LoginModel.fromJson(jsonDecode(response.body));
        return;
      } else {
        modelData = LoginModel(
            accessToken: "",
            userId: -1,
            isAdmin: false,
            status: response.statusCode);
        return;
      }
    } catch (e) {
      modelData = const LoginModel(
        accessToken: "",
        userId: -1,
        isAdmin: false,
        status: 401,
      );
    }
  }
}
