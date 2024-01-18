import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ExerciseModel.dart';
import 'package:mindcare_app/services/ExerciseService.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class ExerciseDescription extends StatelessWidget {
  final String exerciseId;

  const ExerciseDescription({Key? key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return FutureBuilder<ExerciseResponse>(
                      future: ExerciseService().getExercisesById(exerciseId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data?.data?.isEmpty == true) {
                          return Text(
                              'There is no exercises with Id: $exerciseId');
                        } else {
                          final exercise = snapshot.data!.data![0];
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:Text(
                              exercise.name.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else if (index == 1) {
                    return FutureBuilder<ExerciseResponse>(
                      future: ExerciseService().getExercisesById(exerciseId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data?.data?.isEmpty == true) {
                          return Text(
                              'There is no exercises with Id: $exerciseId');
                        } else {
                          final exercise = snapshot.data!.data![0];
                          return Image.network(
                            exercise.image ?? '',
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}