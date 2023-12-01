import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart'; 
import 'package:mindcare_app/models/ElementModel.dart';

class ElementService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  final List<ElementData> elements = [];

  Future<ElementResponse> getElements(int userId) async {
    try {
      final url = Uri.http(baseURL, '/public/api/elements', {'id': userId.toString()});
      String? authToken = await readToken();
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        ElementResponse elementResponse = ElementResponse.fromJson(json);
        elements.clear();
        elements.addAll(elementResponse.data!);
        isLoading = false;
        notifyListeners();
        return elementResponse;
      } else {
        isLoading = false;
        notifyListeners();
        throw Exception('Failed to load elements. Status code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Error: $error');
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}