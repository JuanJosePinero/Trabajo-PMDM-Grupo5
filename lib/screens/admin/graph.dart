import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/models/UserModel.dart';
import 'package:mindcare_app/screens/admin/line_chart.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final UserService userService = UserService();
  final ElementService elementService = ElementService();
  List<UserData> users = [];
  List<ElementData> elements = [];
  String? selectedUser;
  List<FlSpot> moodData = [];
  List<FlSpot> emotionData = [];
  List<FlSpot> eventData = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final user = await userService.getUsers();
    setState(() {
      users = user;
    });
  }

  Future<List<ElementData>> fetchElementsForUser(String userId, DateTime startDate, DateTime endDate) async {
  await elementService.getElements();
  return elements.where((element) {
    DateTime date = DateTime.parse(element.date!);
    return element == userId && date.isAfter(startDate) && date.isBefore(endDate);
  }).toList();
}

Future<void> _fetchElements() async {
  if (selectedUser != null) {
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime.now().subtract(Duration(days: 120));
    String userId = selectedUser!;

    List<ElementData> userElements = await fetchElementsForUser(userId, startDate, endDate);
    
    setState(() {
      moodData = convertToFlSpotList(userElements, 'mood');
      emotionData = convertToFlSpotList(userElements, 'emotion');
      eventData = convertToFlSpotList(userElements, 'event');
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Page'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  value: selectedUser,
                  hint: const Text("Select User"),
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedUser = newValue;
                      _fetchElements();
                    });
                  },
                  items: users.map<DropdownMenuItem<String>>((UserData user) {
    return DropdownMenuItem<String>(
      value: user.id.toString(), // Asegúrate de que este id coincida con el tipo de dato en ElementData
      child: Text(
        user.name ?? 'Unknown',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }).toList(),
                )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomLineChart (
                  moodData: convertToFlSpotList(elements, 'mood'), // Implementa esta función
                  emotionData: convertToFlSpotList(elements, 'emotion'), // Implementa esta función
                  eventData: convertToFlSpotList(elements, 'event'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> convertToFlSpotList(List<ElementData> elements, String type) {
  return elements
      .where((element) => element.type == type)
      .map((element) {
        double x = DateTime.parse(element.date!).millisecondsSinceEpoch.toDouble();
        // Usa el valor real que deseas graficar para el eje Y.
        // Asegúrate de que 'value' sea el nombre correcto del campo en tus datos de ElementData.
        double y = 40; // Aquí 'value' es el campo numérico de tu ElementData.
        return FlSpot(x, y);
      }).toList();
}
}
