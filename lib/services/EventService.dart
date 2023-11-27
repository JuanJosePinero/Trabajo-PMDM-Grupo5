import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindcare_app/models/EventModel.dart';

class EventService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  static String userEmail = '';
  static String userId = '';
  static String userType = '';
  bool isLoading = true;
  final List<EventData> users = [];
  String user = '';
}
