class User {
  String? user_id;
  String? user_email;
  String? user_name;
  String? user_password;
  String? user_datereg;

  User({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_password,
    required this.user_datereg,
  });

  User.fromJson(Map<String, dynamic> json) {
    user_id = json['userID'];
    user_name = json['userName'];
    user_email = json['userEmail'];
    user_password = json['userPassword'];
    user_datereg = json['userDateReg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = user_id;
    data['userName'] = user_name;
    data['userEmail'] = user_email;
    data['userPassword'] = user_password;
    data['userDateReg'] = user_datereg;
    return data;
  }
}