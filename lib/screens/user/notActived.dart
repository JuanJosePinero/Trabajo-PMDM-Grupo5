import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class notActived extends StatelessWidget {
  const notActived({Key? key}) : super(key: key);

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
            'Admin must activate your account \nif you want to use the app. \n\nPlease wait until your acount is activated.',
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}