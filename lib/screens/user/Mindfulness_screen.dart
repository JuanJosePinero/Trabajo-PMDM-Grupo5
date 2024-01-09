import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:mindcare_app/models/ExerciseModel.dart';
import 'package:mindcare_app/services/ExerciseService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class MindFulnessScreen extends StatelessWidget {
  const MindFulnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    final cardHeight = (cardWidth * 0.7);
    final exerciseService = ExerciseService();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: ListView(
          children: [
            const Center(child: Text("Meditation")),
            buildSwiperMeditation(cardWidth, cardHeight, exerciseService, 'Meditation'), // Pasa el tipo 'meditation'
            const Center(child: Text("Relaxation")),
            buildSwiperRelaxation(cardWidth, cardHeight, exerciseService, 'Relaxation'), // Pasa el tipo 'relaxation'
            const Center(child: Text("Breathing")),
            buildSwiperBreathing(cardWidth, cardHeight, exerciseService, 'Breathing'), // Pasa el tipo 'breathing'
          ],
        ),
      ),
    );
  }

  Widget buildSwiperMeditation(double cardWidth, double cardHeight, ExerciseService exerciseService, String type) {
    return FutureBuilder<ExerciseResponse>(
      future: exerciseService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
          return const Text('No exercises available');
        } else {
          final exercises = snapshot.data!.data!.where((exercise) => exercise.type == type).toList(); // Filtra por tipo
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Swiper(
              itemCount: exercises.length,
              pagination: const SwiperPagination(),
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                return CardWithExerciseInfo(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  imagePath: 'assets/screen_images/meditacion.png',
                  exerciseName: exercise.name ?? 'Nombre de Ejercicio Predeterminado',
                );
              },
              autoplay: true,
            ),
          );
        }
      },
    );
  }

  Widget buildSwiperRelaxation(double cardWidth, double cardHeight, ExerciseService exerciseService, String type) {
    return FutureBuilder<ExerciseResponse>(
      future: exerciseService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
          return const Text('No exercises available');
        } else {
          final exercises = snapshot.data!.data!.where((exercise) => exercise.type == type).toList(); // Filtra por tipo
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Swiper(
              itemCount: exercises.length,
              pagination: const SwiperPagination(),
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                return CardWithExerciseInfo(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  imagePath: 'assets/screen_images/relaxation.png',
                  exerciseName: exercise.name ?? 'Nombre de Ejercicio Predeterminado',
                );
              },
              autoplay: true,
            ),
          );
        }
      },
    );
  }

  Widget buildSwiperBreathing(double cardWidth, double cardHeight, ExerciseService exerciseService, String type) {
    return FutureBuilder<ExerciseResponse>(
      future: exerciseService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
          return const Text('No exercises available');
        } else {
          final exercises = snapshot.data!.data!.where((exercise) => exercise.type == type).toList(); // Filtra por tipo
          return Container(
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Swiper(
              itemCount: exercises.length,
              pagination: const SwiperPagination(),
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                return CardWithExerciseInfo(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  imagePath: 'assets/screen_images/breathing.png',
                  exerciseName: exercise.name ?? 'Nombre de Ejercicio Predeterminado',
                );
              },
              autoplay: true,
            ),
          );
        }
      },
    );
  }
}


class CardWithExerciseInfo extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final String imagePath;
  final String exerciseName;

  CardWithExerciseInfo({
    required this.cardWidth,
    required this.cardHeight,
    required this.imagePath,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Hace que la imagen ocupe todo el tamaño del contenedor
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Text(
                exerciseName,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
