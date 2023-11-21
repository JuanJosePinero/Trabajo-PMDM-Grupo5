import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EmotionCard(),
    );
  }
}

class EmotionCard extends StatelessWidget {
  const EmotionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Details'),
      ),
      body: _buildEmotionDetails(),
    );
  }

  Widget _buildEmotionDetails() {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeColors.getGradient(),
      ),
      child: Container(
        width: double.infinity, // Ocupa todo el ancho de la pantalla
        height: double.infinity, // Ocupa todo el alto de la pantalla
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AddImageCustomButton(
              onPressed: () {
                // Lógica para añadir imagen
              },
              text: 'Add Image',
            ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Text('Name:', style: TextStyle(fontSize: 20),),
                SizedBox(width: 8.0),
                Expanded(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    child: IntrinsicWidth(
                      child: TextField(
                        // Configura el controlador, estilo y otras propiedades según tus necesidades
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const SizedBox(width: 0.0),
                const Text('Hour:', style: TextStyle(fontSize: 20),),
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
                const SizedBox(width: 0.0),
                const Text('Hour:', style: TextStyle(fontSize: 20),),
                const SizedBox(width: 8.0),
                Text(
                  _getFormattedTime(),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.day}/${now.month}/${now.year}";
    return formattedDate;
  }

  String _getFormattedTime() {
    final DateTime now = DateTime.now();
    final String formattedTime =
        "${now.hour}:${now.minute}:${now.second}";
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
