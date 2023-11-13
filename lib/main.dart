import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/access/loadingScreen.dart';

void main() => runApp(const MindCare());

class MindCare extends StatelessWidget {
  const MindCare({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Mindcare',
        debugShowCheckedModeBanner: false,
        home: LoadingScreen());
  }
}
