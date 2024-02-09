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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomLineChart(
                  moodData: moodData,
                  emotionData: emotionData,
                  eventData: eventData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAndCountElements() async {
    if (selectedUser != null) {
      DateTime endDate = DateTime.now();
      DateTime startDate = DateTime.now().subtract(const Duration(days: 120));
      String userId = selectedUser!;

      try {
        List<ElementData> userElements =
            await elementService.fetchElementsForUserByMonth(userId, startDate, endDate);
        Map<DateTime, List<ElementData>> groupedElementsByMonth =
            elementService.groupElementsByMonth(userElements);
        Map<DateTime, Map<String, int>> countsByMonth =
            elementService.countElementsByMonth(groupedElementsByMonth);

        List<FlSpot> moodDataList = [];
        List<FlSpot> emotionDataList = [];
        List<FlSpot> eventDataList = [];

        countsByMonth.forEach((monthStart, counts) {
          double x = monthStart.millisecondsSinceEpoch.toDouble();
          int maxCount = counts.values.reduce((value, element) => value > element ? value : element);

          moodDataList.add(FlSpot(x, counts['mood']!.toDouble()));
          emotionDataList.add(FlSpot(x, counts['emotion']!.toDouble()));
          eventDataList.add(FlSpot(x, counts['event']!.toDouble()));
        });

        setState(() {
          moodData = moodDataList;
          emotionData = emotionDataList;
          eventData = eventDataList;
          print(moodData);
          print(emotionData);
          print(eventData);
        });
      } catch (e) {
        print('Error fetching and counting elements: $e');
      }
    }
  }
}

