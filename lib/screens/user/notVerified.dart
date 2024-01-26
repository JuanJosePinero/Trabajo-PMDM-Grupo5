import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class notVerified extends StatelessWidget {
  const notVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: ThemeColors.getGradient()),
        child: const Center(
          child: Text(
            'You must verify your account \nif you want to use the app. \n\nYou need to watch your email\n to verify your account.',
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}