import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/services/UserService.dart';

class ElementService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  final List<ElementData> elements = [];

  static String id_user = '';
  static String type = '';

  Future<ElementResponse> getElements() async {
    try {
      final url = Uri.http(baseURL, '/public/api/elements',
          {'id': UserService.userId.toString()});
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
        throw Exception(
            'Failed to load elements. Status code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Error: $error');
    }
  }

  Future newElement(
    String id_user,
    String type_user,
    String type,
    String date, {
    int? mood_id,
    int? emotion_id,
    String? description,
  }) async {
    final Map<String, dynamic> elementData = {
      'id_user': id_user,
      'type_user': type_user,
      'type': type,
      'date': date,
    };
    if (mood_id != null) {
      elementData['mood_id'] = mood_id;
    }
    if (description != null) {
      elementData['description'] = description;
    }
    if (emotion_id != null) {
      elementData['emotion_id'] = emotion_id;
    }

    final url = Uri.http(baseURL, '/public/api/newElement', {});
    String? authToken = await readToken();

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(elementData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      ElementService.id_user = decoded['data']['id_user'].toString();
      ElementService.type = decoded['data']['type'].toString();
      return 'success';
    } else {
      return 'error';
    }
  }

  Future<ElementResponse> getEmotions() async {
    try {
      final url = Uri.http(baseURL, '/public/api/emotions', {});
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
        throw Exception(
            'Failed to load emotions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Error: $error');
    }
  }

  Future<ElementResponse> getMoods() async {
    try {
      final url = Uri.http(baseURL, '/public/api/moods', {});
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
        throw Exception(
            'Failed to load moods. Status code: ${response.statusCode}');
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

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }

  // Report Screen -----------------------------------------------------------------------------------------------------------------------------

  List<ElementData> moodElements = [];
  List<ElementData> eventElements = [];
  List<ElementData> emotionElements = [];
  List<ElementData> elementsList = [];

  Future<void> obtenerElementos(DateTime startDate, DateTime endDate, bool isMoodsChecked, bool isEventsChecked, bool isEmotionsChecked) async {
    try {
      ElementResponse response = await getElements();
      if (response.success == true) {
        response.data?.forEach((element) {
          if (element.type == 'mood') {
            moodElements.add(element);
          } else if (element.type == 'event') {
            eventElements.add(element);
          } else if (element.type == 'emotion') {
            emotionElements.add(element);
          }
        });

        // Filtros por fecha y tipo
        moodElements = moodElements.where((element) => isElementInDateRange(element, startDate, endDate) && isMoodsChecked).toList();
        eventElements = eventElements.where((element) => isElementInDateRange(element, startDate, endDate) && isEventsChecked).toList();
        emotionElements = emotionElements.where((element) => isElementInDateRange(element, startDate, endDate) && isEmotionsChecked).toList();

        elementsList.clear();
        elementsList.addAll(moodElements);
        elementsList.addAll(eventElements);
        elementsList.addAll(emotionElements);
      } else {
        print('Error al obtener elementos: ${response.message}');
      }
    } catch (error) {
      print('Error al obtener elementos: $error');
    }
  }

  bool isElementInDateRange(ElementData element, DateTime startDate, DateTime endDate) {
    DateTime elementDate = DateTime.parse(element.date!);
    return elementDate.isAfter(startDate) && elementDate.isBefore(endDate);
  }


  // --------------------------------------------------------------------------------------------------------------------------------------
//   Future<void> countElementTypes(DateTime startDate, DateTime endDate) async {
//   moodCount = await countElementsOfType('mood', startDate, endDate);
//   emotionCount = await countElementsOfType('emotion', startDate, endDate);
//   eventCount = await countElementsOfType('event', startDate, endDate);
// }

  Future<int> countElementsOfType(String type, DateTime startDate, DateTime endDate, String userId) async {
  await getElements();
  return elements.where((element) {
    DateTime date = DateTime.parse(element.date!);
    bool isUserMatch = userId == userId; // Asumiendo que ElementData tiene un campo userId
    return element.type == type && date.isAfter(startDate) && date.isBefore(endDate) && isUserMatch;
  }).length;
}



// HAY QUE HACER LOS SIGUIENTES METODOS:
//
// Recoger elementos de usuarios y meterlos en listas (parecido a este: obtenerElementos())
// Filtrar los elementos por cada mes
// Hacerles un count a los elementos por mes



}
