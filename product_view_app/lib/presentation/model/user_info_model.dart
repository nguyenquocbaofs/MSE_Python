class UserInfoModel {
  String username;
  String email;
  String mobile;
  String address;
  String gender;

  UserInfoModel({
    required this.username,
    required this.email,
    required this.mobile,
    required this.address,
    required this.gender,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      username: json['Username'] ?? "",
      email: json['Email'] ?? "",
      mobile: json['Mobile'] ?? '',
      address: json['Address'] ?? "",
      gender: json['Gender'] ?? "",
    );
  }
}
