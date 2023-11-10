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

  // Getters
  int? get getId => id;
  String? get getName => name;
  String? get getEmail => email;
  int? get getEmailConfirmed => emailConfirmed;
  DateTime? get getEmailVerifiedAt => emailVerifiedAt;
  int? get getActived => actived;
  String? get getType => type;
  int? get getCode => code;
  String? get getPassword => password;
  int? get getRememberToken => rememberToken;
  int? get getDeleted => deleted;
  DateTime? get getCreatedAt => createdAt;
  DateTime? get getUpdatedAt => updatedAt;

  // Setters
  set setId(int? value) => id = value;
  set setName(String? value) => name = value;
  set setEmail(String? value) => email = value;
  set setEmailConfirmed(int? value) => emailConfirmed = value;
  set setEmailVerifiedAt(DateTime? value) => emailVerifiedAt = value;
  set setActived(int? value) => actived = value;
  set setType(String? value) => type = value;
  set setCode(int? value) => code = value;
  set setPassword(String? value) => password = value;
  set setRememberToken(int? value) => rememberToken = value;
  set setDeleted(int? value) => deleted = value;
  set setCreatedAt(DateTime? value) => createdAt = value;
  set setUpdatedAt(DateTime? value) => updatedAt = value;
}