import 'dart:convert';

class LoginModel {
  final String accessToken;
  final int userId;
  final bool isAdmin;
  final int status;

  const LoginModel({
    required this.accessToken,
    required this.userId,
    required this.isAdmin,
    required this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var parts = json["access_token"].split('.');
    var payload = parts[1];
    var decodedPayload = utf8.decode(base64Url.decode(payload));
    var jsonPayload = jsonDecode(decodedPayload);
    int userId = -1;
    bool isAdmin = false;
    int status = 200;
    if (jsonPayload != null) {
      var jsonSub = jsonDecode(jsonPayload["sub"]);
      userId = jsonSub["user_id"];
      isAdmin = jsonSub["is_admin"];
    } else {
      status = 400;
    }

    return switch (json) {
      {
        'access_token': String accessToken,
      } =>
        LoginModel(
          accessToken: accessToken,
          userId: userId,
          isAdmin: isAdmin,
          status: status,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
