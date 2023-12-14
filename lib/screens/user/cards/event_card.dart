import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/themes/themeColors.dart';

final TextEditingController whatHappenedController = TextEditingController();
final TextEditingController talkAboutItController = TextEditingController();

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: _buildMoodDetails(context),
    );
  }

  Widget _buildMoodDetails(BuildContext context) {
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
                    // const Row(children: [
                    //   Text(
                    //     'You need to write a description below\n',
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    // ]),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[300],
                    //     borderRadius: BorderRadius.circular(8.0),
                    //   ),
                    //   child: TextField(
                    //     controller: whatHappenedController,
                    //     style: const TextStyle(fontSize: 16.0),
                    //   ),
                    // ),
                    // const SizedBox(height: 16.0),
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
                        controller: talkAboutItController,
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
                    const Icon(Icons.calendar_month_outlined),
                    const SizedBox(width: 12.0),
                    const Text(
                      'Date:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      _getFormattedDate(),
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
                      _saveCard(context);
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

  bool whatHappenEmpty() {
    if (whatHappenedController.text.isEmpty) return true;
    return false;
  }

  void _saveCard(BuildContext context) {
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
        talkAboutItController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    }
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }

  String _getFormattedTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }
}
