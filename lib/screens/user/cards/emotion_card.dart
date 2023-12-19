import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

String? selectedValue = 'DefaultEmotion';

class EmotionCard extends StatefulWidget {
  EmotionCard({Key? key}) : super(key: key);

  @override
  _EmotionCardState createState() => _EmotionCardState();
}

class _EmotionCardState extends State<EmotionCard> {
  late ElementService _elementService;
  List<ElementData> _elements = [];
  List<ElementData> _emotions = [];
  String _emotionImage =
      'https://mindcare.allsites.es/public/images/default_create_imgs.jpg';
  // String _emotionImage = 'assets/screen_images/default_create.jpg';
  ElementData? _selectedEmotion;

  @override
  void initState() {
    super.initState();
    _elementService = ElementService();

    _loadElements();
    _loadEmotions();
    selectedValue = 'DefaultEmotion';
  }

  Future<void> _loadEmotions() async {
    try {
      ElementResponse response = await _elementService.getEmotions();
      setState(() {
        _emotions = response.data ?? [];
      });
    } catch (error) {
      print('Error al cargar los emotions: $error');
    }
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.day}/${now.month}/${now.year}";
    return formattedDate;
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
              child: CachedNetworkImage(
                imageUrl: _emotionImage,
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
                  'Emotion:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButton<ElementData>(
                    hint: const Text('Select a Emotion'),
                    value: _selectedEmotion,
                    onChanged: (ElementData? newValue) {
                      setState(() {
                        _selectedEmotion = newValue;
                        selectedValue = newValue.toString();
                        _updateImageFromEmotion(newValue?.name);
                      });
                    },
                    items: _emotions.map((ElementData mood) {
                      return DropdownMenuItem<ElementData>(
                        value: mood,
                        child: Text(
                          _truncateText(mood.name ?? 'No name available', 18),
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

  void _updateImageFromEmotion(String? emotionName) {
    final emotion = _emotions.firstWhere(
        (emotion) => emotion.name == emotionName,
        orElse: () => ElementData());

    if (emotion.image != null) {
      setState(() {
        _emotionImage = emotion.image!;
      });
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  void _saveCard(BuildContext context) {
    if (selectedValue == 'DefaultEmotion') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Please choose an emotion')),
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
          UserService.userId, 'u', 'emotion', formattedDate,
          emotion_id: 5);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Column(
            children: [
              SizedBox(height: 4),
              Center(child: Text('Emotion saved successfully!')),
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
