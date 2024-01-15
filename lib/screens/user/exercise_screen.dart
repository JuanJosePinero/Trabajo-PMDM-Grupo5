import 'package:flutter/material.dart';

class ExerciseDescription extends StatelessWidget {
  final int? exerciseId; 

  const ExerciseDescription({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulnes'),
      ),
      body: Center(
        child: Text('Ejercicio ID: $exerciseId'), 
      ),
    );
  }
}

