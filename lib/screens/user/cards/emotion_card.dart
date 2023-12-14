import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class EmotionCard extends StatefulWidget {
  EmotionCard({Key? key}) : super(key: key);

  @override
  _EmotionCardState createState() => _EmotionCardState();
}

class _EmotionCardState extends State<EmotionCard> {
late ElementService _elementService;
  List<ElementData> _elements = [];

  @override
  void initState() {
    super.initState();
    _elementService = ElementService();

    // Llama a getElements al iniciar
    _loadElements();
  }

  Future<void> _loadElements() async {
    try {
      ElementResponse response = await _elementService.getElements();
      setState(() {
        _elements = response.data ?? [];
      });
    } catch (error) {
      print('Error al cargar elementos: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Details'),
      ),
      body: _buildEmotionDetails(context),
    );
  }

  Widget _buildEmotionDetails(BuildContext context) {
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
            Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/screen_images/default_create.jpg'),
              ),
              ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.mood),
                const SizedBox(width: 12.0),
                const Text(
                  'Emotion:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Select a emotion'),
                    value: _selectedEmotion,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmotion = newValue;
                      });
                    },
                    items: _emotionList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
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
                    "The Emotion Card is a personalized reflection of your daily emotional experiences. This card allows you to document and explore the array of emotions you have felt throughout the day. Whether it's joy, sadness, excitement, or tranquility, the Emotion Card serves as a visual and emotional diary, offering you the opportunity to delve into and better understand the complex tapestry of your feelings.",
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

  void _saveCard(BuildContext context) {
    // if (      ) {
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

   String? _selectedEmotion; 
  List<String> _emotionList = [
    'Happy',
    'Sad',
    'Angry',
    'Calm',
    'Excited',
    'Stressed',
    'Tired',
  ];
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
