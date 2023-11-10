class Users {
  bool? success;
  List<UserData>? data;
  String? message;

  Users({this.success, this.data, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  int? emailConfirmed;
  DateTime? emailVerifiedAt;
  int? actived;
  String? type;
  int? code;
  String? password;
  int? rememberToken;
  int? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserData(
      {this.id,
      this.name,
      this.email,
      this.emailConfirmed,
      this.emailVerifiedAt,
      this.actived,
      this.type,
      this.code,
      this.password,
      this.rememberToken,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailConfirmed = json['email_confirmed'];
    emailVerifiedAt = json['email_verified_at'];
    actived = json['actived'];
    type = json['type'];
    code = json['code'];
    password = json['password'];
    rememberToken = json['remember_token'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_confirmed'] = emailConfirmed;
    data['email_verified_at'] = emailVerifiedAt;
    data['actived'] = actived;
    data['type'] = type;
    data['code'] = code;
    data['password'] = password;
    data['remember_token'] = rememberToken;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}