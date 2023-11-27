import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/themes/themeColors.dart';

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
                    const Row(children: [
                      Icon(Icons.smart_button),
                      Text(
                        ' What happened:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: TextEditingController(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Row(children: [
                      Icon(Icons.text_decrease),
                      Text(
                        ' Wanna talk about it?',
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
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
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12.0),
                    const Text(
                      'Hour:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      _getFormattedTime(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
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
                const SizedBox(height: 32.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCard(BuildContext context) {
    // Muestra un SnackBar durante 2 segundos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Card saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    // Espera 2 segundos y luego navega a MainScreen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()), // Asegúrate de tener la clase MainScreen
      );
    });
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

class AddImageCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AddImageCustomButton(
      {required this.onPressed, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300], // Color grisáceo
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.grey, // Borde de líneas discontinuas de color gris
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
