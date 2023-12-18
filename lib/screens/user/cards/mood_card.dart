import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:mindcare_app/models/ElementModel.dart';

import '../../../services/UserService.dart';

String selectedValue = 'DefaultMood';

class MoodCard extends StatefulWidget {
  MoodCard({Key? key}) : super(key: key);

  @override
  _MoodCardState createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {
  late ElementService _elementService;
  List<ElementData> _moods = [];
  String _moodImage =
      'https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg';
  // String _moodImage = 'assets/screen_images/default_create.jpg';
  ElementData? _selectedMood;

  @override
  void initState() {
    super.initState();
    _elementService = ElementService();
    _loadMoods();
    selectedValue = 'DefaultMood';
  }

  Future<void> _loadMoods() async {
    try {
      ElementResponse response = await _elementService.getMoods();
      setState(() {
        _moods = response.data ?? [];
      });
    } catch (error) {
      print('Error al cargar los moods: $error');
    }
  }

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
            Center(
              child: CachedNetworkImage(
                imageUrl: _moodImage,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 200,
                height: 200,
              ),
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
                Expanded(
                  child: DropdownButton<ElementData>(
                    hint: const Text('Select a mood'),
                    value: _selectedMood,
                    onChanged: (ElementData? newValue) {
                      setState(() {
                        _selectedMood = newValue;
                        selectedValue = newValue.toString();
                        _updateImageFromMood(newValue?.description);
                      });
                    },
                    items: _moods.map((ElementData mood) {
                      return DropdownMenuItem<ElementData>(
                        value: mood,
                        child: Text(
                          _truncateText(
                              mood.description ?? 'No description available',
                              18),
                        ),
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

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  void _updateImageFromMood(String? moodDescription) {
    final mood = _moods.firstWhere(
        (mood) => mood.description == moodDescription,
        orElse: () => ElementData());

    if (mood.image != null) {
      setState(() {
        _moodImage = mood.image!;
      });
    }
  }

  void _saveCard(BuildContext context) {
    if (selectedValue == 'DefaultMood') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Please select a mood.')),
              SizedBox(height: 40),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final DateTime now = DateTime.now();
      final String formattedDate = "${now.year}-${now.month}-${now.day}";
      ElementService().newElement(
          UserService.userId, 'u', 'mood', formattedDate,
          mood_id: 5);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Mood saved successfully')),
              SizedBox(height: 40),
            ],
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    }
  }
}
