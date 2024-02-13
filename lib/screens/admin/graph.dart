import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/models/UserModel.dart';
import 'package:mindcare_app/screens/admin/line_chart.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final UserService userService = UserService();
  final ElementService elementService = ElementService();
  List<UserData> users = [];
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
                        print(newValue);
                        _fetchAndCountElements();
                      });
                    },
                    items: users.map<DropdownMenuItem<String>>((UserData user) {
                      return DropdownMenuItem<String>(
                        value: user.id.toString(),
                        child: Text(
                          user.name ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: CustomLineChart(
            //       moodData: moodData,
            //       emotionData: emotionData,
            //       eventData: eventData,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _fetchAndCountElements() async {
  if (selectedUser != null) {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final DateTime startDate = firstDayOfCurrentMonth.subtract(Duration(days: 120)); // Últimos 4 meses
    final DateTime endDate = firstDayOfCurrentMonth.subtract(const Duration(days: 1)); // Hasta el último día del mes anterior

    // Imprime el rango de fechas para depuración
    print('Rango de Fechas: Desde ${startDate.toIso8601String()} hasta ${endDate.toIso8601String()}');

    try {
      // Encuentra el nombre del usuario seleccionado
      final userName = users.firstWhere((user) => user.id.toString() == selectedUser, orElse: () => UserData()).name ?? "Unknown";
      print('Usuario seleccionado: $userName, ID: $selectedUser');

      // Obtiene y filtra los elementos por usuario y fecha
      final Map<DateTime, Map<String, int>> countsByMonth = await elementService.getElementsByGraphicDate(selectedUser!, startDate, endDate);

      if (countsByMonth.isNotEmpty) {
        countsByMonth.forEach((monthStart, counts) {
          print('Mes: ${monthStart.month}-${monthStart.year}, Elementos: $counts');
        });

        final int totalElements = countsByMonth.values.map((counts) => counts.values.reduce((sum, elementCount) => sum + elementCount)).reduce((sum, monthSum) => sum + monthSum);
        print('Número total de elementos en el rango de fechas: $totalElements');
      } else {
        print('No se encontraron elementos para el usuario seleccionado en el rango de fechas dado.');
      }
    } catch (e) {
      print('Error al obtener y contar los elementos: $e');
    }
  }
}
}