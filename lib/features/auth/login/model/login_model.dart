class Login {
  bool? success;
  String? message;
  Data? data;

  Login({this.success, this.message, this.data});

  Login.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  int? accessTokenExpiresIn;
  String? refreshToken;
  int? refreshTokenExpiresIn;

  Data(
      {this.accessToken,
      this.accessTokenExpiresIn,
      this.refreshToken,
      this.refreshTokenExpiresIn});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExpiresIn = json['accessTokenExpiresIn'];
    refreshToken = json['refreshToken'];
    refreshTokenExpiresIn = json['refreshTokenExpiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['accessTokenExpiresIn'] = accessTokenExpiresIn;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpiresIn'] = refreshTokenExpiresIn;
    return data;
  }
}
