import 'package:flutter/material.dart';

void main() => runApp(const MindCare());

class MindCare extends StatelessWidget {
  const MindCare({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindcare',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
