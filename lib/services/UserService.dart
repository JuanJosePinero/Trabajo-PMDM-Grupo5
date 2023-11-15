
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/UserModel.dart';

class UserService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  static String userEmail = '';
  static String userId = '';
  static String userType = '';
  bool isLoading = true;
  final List<UserData> users = [];
  String user = '';

  Future register(
    String name,
    String email,
    String password,
    String cpassword,
  ) async {
    final Map<String, dynamic> authData = {
      'name': name,
      'email': email,
      'password': password,
      'c_password': cpassword,
    };

    final url = Uri.http(baseURL, '/public/api/register', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(
          key: 'name', value: decoded['data']['name'].toString());
    } else {
      if (decoded['data']['error'] == "The email has already been taken") {
        return "The email has already been taken";
      } else {
        return decoded['message'];
      }
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(baseURL, '/public/api/login', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      UserService.userId = decoded['data']['id'].toString();
      UserService.userEmail = email;
      UserService.userType = decoded['data']['type'];
      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(key: 'id', value: decoded['data']['id'].toString());
      return 'success';
    } else {
      if (decoded['data']['error'] == "Email don't confirmed") {
        return 'Email not confimed';
      } else if (decoded['data']['error'] == "User don't activated") {
        return 'User not activated';
      } else {
        return decoded['message'];
      }
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'id');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }

  Future<List<UserData>> getUsers() async {
    final url = Uri.http(baseURL, '/public/api/users');
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decode = json.decode(resp.body);
    var user = Users.fromJson(decode);
    users.clear();
    users.addAll(user.data!.where((userData) => userData.deleted == 0));
    isLoading = false;
    notifyListeners();
    return users;
  }

//Revisar metodo getUser para optimizar y verle uso.

  Future<UserData> getUser(String id) async {
    String? token = await readToken();

    final url = Uri.http(baseURL, '/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decode = json.decode(resp.body);
    UserData user = UserData.fromJson(decode['data']);
    isLoading = false;
    notifyListeners();
    return user;
  }

  Future postActivate(String id) async {
    final url = Uri.http(baseURL, '/activate', {'user_id': id});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({'id': userId}),
    );

    final Map<String, dynamic> decode = json.decode(resp.body);
    if(decode['success'] == true){
      return true;
    }else {
      return false;
    }
  }

  Future postDeactivate(String id) async {
    final url = Uri.http(baseURL, '/deactivate', {'user_id': id});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({'id': userId}),
    );

    final Map<String, dynamic> decode = json.decode(resp.body);
    if(decode['success'] == true){
      return true;
    }else {
      return false;
    }
  }

  Future postDelete(String id) async {
    final url = Uri.http(baseURL, '/deleteUser/$id');
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({'id': userId}),
    );

    final Map<String, dynamic> decode = json.decode(resp.body);
    if(decode['success'] == true){
      return true;
    }else {
      return false;
    }
  }

  Future postUpdate(
    String id,
    String name,
  ) async {
    final Map<String, dynamic> updateData = {
      'user_id': id,
      'name': name,
    };
    final url = Uri.http(baseURL, '/updateUser/$id');
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: json.encode(updateData));
    final Map<String, dynamic> decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('error');
      print(decoded.toString());
    }
  }
}