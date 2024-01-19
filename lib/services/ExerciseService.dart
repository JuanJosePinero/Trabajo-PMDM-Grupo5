import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindcare_app/models/ExerciseModel.dart';
import 'package:mindcare_app/services/UserService.dart';

class ExerciseService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  static String user_id = '';
  static String exercise_id = '';
  bool isLoading = true;
  final List<ExerciseData> exercises = [];

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }

  Future<ExerciseResponse> getExercises() async {
    try {
      final url = Uri.http(baseURL, '/public/api/exercises');
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
        ExerciseResponse exerciseResponse = ExerciseResponse.fromJson(json);
        exercises.clear();
        exercises.addAll(exerciseResponse.data!);
        isLoading = false;
        notifyListeners();
        return exerciseResponse;
      } else {
        isLoading = false;
        notifyListeners();
        throw Exception(
            'Failed to load exercises. Status code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Error: $error');
    }
  }

  Future exerciseMade(
    String user_id,
    String exercise_id,
  ) async {
    final Map<String, dynamic> exerciseData = {
      'user_id': user_id,
      'exercise_id': exercise_id,
    };
    final url = Uri.http(baseURL, '/public/api/newExerciseMade', {});
    String? authToken = await readToken();

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(exerciseData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      ExerciseService.user_id = decoded['data']['user_id'].toString();
      ExerciseService.exercise_id = decoded['data']['exercise_id'].toString();
      return 'success';
    } else {
      return 'error';
    }
  }

  Future<ExerciseResponse> getExercisesByAlumn() async {
    try {
      final url = Uri.http(baseURL, '/public/api/exercisesByAlum', {
        'id': UserService.userId.toString(),
      });
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
        ExerciseResponse exerciseResponse = ExerciseResponse.fromJson(json);
        exercises.clear();
        exercises.addAll(exerciseResponse.data!);
        isLoading = false;
        notifyListeners();
        return exerciseResponse;
      } else {
        isLoading = false;
        notifyListeners();
        throw Exception(
            'Failed to load exercises. Status code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Error: $error');
    }
  }

  Future<ExerciseData> getExerciseById(String exerciseId) async {
    String? token = await readToken();

    final Uri url = Uri.https(
        baseURL, '/public/api/exerciseById', {'id': exerciseId.toString()});

    Map<String, dynamic> requestData = {
      'id': exerciseId.toString(),
    };

    final resp = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestData),
    );

    exercises.clear();

    final Map<String, dynamic> decoded = json.decode(resp.body);
    if (decoded['success'] == true) {
      ExerciseData exerciseData = ExerciseData(
        id: decoded['data']['id'],
        name: decoded['data']['name'] ?? '',
        improvement: decoded['data']['improvement'] ?? '',
        type: decoded['data']['type'] ?? '',
        explanation: decoded['data']['explanation'] ?? '',
        image: decoded['data']['image'] ?? '',
        audio: decoded['data']['audio'] ?? '',
        video: decoded['data']['video'] ?? '',
        made: decoded['data']['made'] ?? '',
      );
      exercises.add(exerciseData);

      isLoading = false;
      notifyListeners();
      return exerciseData;
    } else {
      throw Exception(decoded['message'] ?? 'Failed to retrieve exercise');
    }
  }
}
