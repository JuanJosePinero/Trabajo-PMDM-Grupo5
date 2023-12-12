import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class MoodCard extends StatelessWidget {
  const MoodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Details'),
      ),
      body: _buildMoodDetails(context),
    );
  }

  Widget _buildMoodDetails(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeColors.getGradient(),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AddImageCustomButton(
              onPressed: () {
                _showHorizontalButtonDialog(context);
              },
              text: 'Select your mood',
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.mood),
                const SizedBox(width: 12.0),
                const Text(
                  'Mood:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8.0),
                Center(
                  child: Expanded(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: IntrinsicWidth(
                        child: TextField(
                          controller: TextEditingController(text: 'Your mood'),
                          readOnly: true,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
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
                    "The Mood Card is a snapshot of your overall mood and mental well-being. It provides a space to capture your predominant emotional state and offers insights into the factors influencing your mood. Whether you're feeling upbeat, calm, or reflective, the Mood Card assists you in tracking and recognizing patterns in your emotional landscape, fostering self-awareness and emotional intelligence.",
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
    );
  }

  void _showHorizontalButtonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            width: 300, // Adjust the width as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select an Option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildHorizontalButtonList(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalButtonList() {
    return SizedBox(
      height: 100, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Adjust the number of items as needed
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                // Handle button click here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button $index clicked')),
                );
              },
              child: Text('Button $index'),
            ),
          );
        },
      ),
    );
  }

  void _saveCard(BuildContext context) {
    // if (whatHappenEmpty()) {
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
    // } else {
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
      // whatHappenedController.clear();
      // talkAboutItController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
    // }
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
          backgroundColor: Colors.grey[300], // Color grisaceo
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
