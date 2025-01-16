import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_view_app/constraint/constaint.dart';
import 'package:product_view_app/presentation/model/user_info_model.dart';

class UserInfoController {
  static final UserInfoController _instance = UserInfoController._internal();

  UserInfoModel modelData = UserInfoModel(
    username: "",
    email: "",
    mobile: "",
    address: "",
    gender: "",
  );

  factory UserInfoController() {
    return _instance;
  }

  UserInfoController._internal();

  Future<void> getUserInfo(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse("$host/api/user/profile"),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        modelData = UserInfoModel.fromJson(jsonDecode(response.body));
        return;
      } else {
        modelData = UserInfoModel(
          address: '',
          email: '',
          gender: '',
          mobile: '',
          username: '',
        );
        return;
      }
    } catch (e) {
      modelData = UserInfoModel(
        address: '',
        email: '',
        gender: '',
        mobile: '',
        username: '',
      );
    }
  }

  Future<void> editUserInfo(String accessToken, String mobile, String address, String gender) async {
    String body = jsonEncode({
      "Mobile": mobile,
      "Address": address,
      "Gender": gender,
    });
    int contentLength = body.length;
    try {
      final response = await http.post(
        Uri.parse("$host/api/auth/login"),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Content-Length': contentLength.toString(),
        },
        body: body,
      );

      if (response.statusCode == 200) {
        await getUserInfo(accessToken);
        return;
      } else {
        return;
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
