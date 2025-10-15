class UserLogData {
  String? countryCode;
  String? phoneNumber;
  String? email;
  String? password;
  String? loginType;

  UserLogData({this.countryCode, this.phoneNumber,this.email, this.password, this.loginType});

  UserLogData.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    email = json['email'];
    loginType = json['login_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    data['email'] = email;
    data['login_type'] = loginType;
    return data;
  }
}
