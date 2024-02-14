import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? selectedUser;
  List<FlSpot> moodData = [];
  List<FlSpot> emotionData = [];
  List<FlSpot> eventData = [];
  List<DateTime> monthStartDates = [];
  bool dataAvailable = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _fetchUsers() async {
    final user = await userService.getUsers();
    setState(() {
      users = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
              height: 20,
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
            const SizedBox(height: 10),
            _buildLegend(),
            Expanded(
  child: Padding(
    padding: const EdgeInsets.all(30.0),
    child: !dataAvailable
        ? const Center(
            child: Text(
              "No data available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: 1.7,
            child: CustomLineChart(
              moodData: moodData,
              emotionData: emotionData,
              eventData: eventData,
              monthStartDates: monthStartDates,
            ),
          ),
  ),
),

          ],
        ),
      ),
    );
  }

  void _fetchAndCountElements() async {
  if (selectedUser != null) {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final DateTime startDate = firstDayOfCurrentMonth.subtract(const Duration(days: 120));
    final DateTime endDate = firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    try {
      final Map<DateTime, Map<String, int>> countsByMonth = await elementService.getElementsByGraphicDate(selectedUser!, startDate, endDate);

      bool hasData = countsByMonth.isNotEmpty && countsByMonth.values.any((counts) => counts.values.any((count) => count > 0));

      if (hasData) {
        processElementData(countsByMonth);
        setState(() {
          dataAvailable = true;
        });
      } else {
        setState(() {
          dataAvailable = false;
        });
      }
    } catch (e) {
      setState(() {
        dataAvailable = false;
      });
    }
  } else {
    setState(() {
      dataAvailable = false;
    });
  }
}


  void processElementData(Map<DateTime, Map<String, int>> countsByMonth) {
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime startDate = firstDayOfCurrentMonth.subtract(const Duration(days: 120));
    DateTime endDate = firstDayOfCurrentMonth.subtract(const Duration(days: 1));

    monthStartDates.clear();
    DateTime current = startDate;
    while (current.isBefore(endDate)) {
      monthStartDates.add(DateTime(current.year, current.month));
      current = DateTime(current.year, current.month + 1);
    }

    moodData.clear();
    emotionData.clear();
    eventData.clear();

    for (var monthDate in monthStartDates) {
      var index = monthStartDates.indexOf(monthDate).toDouble();

      var counts = countsByMonth[DateTime(monthDate.year, monthDate.month)] ??
          {'mood': 0, 'emotion': 0, 'event': 0};

      moodData.add(FlSpot(index, counts['mood']?.toDouble() ?? 0.0));
      emotionData.add(FlSpot(index, counts['emotion']?.toDouble() ?? 0.0));
      eventData.add(FlSpot(index, counts['event']?.toDouble() ?? 0.0));
    }

    setState(() {});
  }

  Widget _buildLegend() {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1), 
      borderRadius: BorderRadius.circular(5), 
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "LineChart Legend",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sans Serif',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.red,
            ),
            const SizedBox(width: 5),
            const Text('Mood'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.yellow,
            ),
            const SizedBox(width: 5),
            const Text('Emotion'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: Colors.green,
            ),
            const SizedBox(width: 5),
            const Text('Event'),
          ],
        ),
          ],
        ),
      ],
    ),
  );
}
}
