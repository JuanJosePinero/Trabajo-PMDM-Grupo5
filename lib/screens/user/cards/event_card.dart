import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

final TextEditingController whatHappenedController = TextEditingController();

class EventCard extends StatefulWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: _buildEventDetails(context),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    return Slidable(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Row(children: [
                      Icon(Icons.text_decrease),
                      Text(
                        'Write a description about your event',
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: whatHappenedController,
                        minLines: 8,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text('When did it happen?'),
                    ),
                    const SizedBox(width: 12.0),
                    const Text(
                      'Date:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                const Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 12.0),
                    Text(
                      'Information card:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8.0),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "The Event Card serves as a record of significant moments and occurrences in your life. This card allows you to document and celebrate milestones, achievements, or noteworthy happenings. Whether it's a special celebration, a personal accomplishment, or a memorable experience, the Event Card is a tool for acknowledging and cherishing the positive events that contribute to your overall well-being.",
                        style: TextStyle(fontSize: 11.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveCard(context, formattedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Save Card',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  bool whatHappenEmpty() {
    if (whatHappenedController.text.isEmpty) return true;
    return false;
  }

  void _saveCard(BuildContext context, String formattedDate) {
    if (whatHappenEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Please fill the fields')),
              SizedBox(height: 40),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      String descriptionText = whatHappenedController.text;
      ElementService().newElement(
        UserService.userId,
        'u',
        'event',
        selectedDate.toString(),
        description: descriptionText,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Event saved successfully')),
              SizedBox(height: 40),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        whatHappenedController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    }
  }

  String _getFormattedDate2() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day}";
    return formattedDate;
  }
}
