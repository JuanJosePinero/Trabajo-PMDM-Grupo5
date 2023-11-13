import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/access/welcome.dart';
import 'package:mindcare_app/themes/themeColors.dart';

import 'login.dart';
import 'signup.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Redirigir a WelcomePage después de 4 segundos
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: ThemeColors.getGradient()
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'M',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightBlue,
                  ),
                  children: [
                    TextSpan(
                      text: 'ind',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                    TextSpan(
                      text: 'C',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 40,
                      ),
                    ),
                    TextSpan(
                      text: 'ar',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                    TextSpan(
                      text: 'e',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 125,
                width: 125,
                child: Image.asset('assets/screen_images/heart.gif'),
              ),
              const SizedBox(height: 175),
              SizedBox(
                height: 125,
                width: 125,
                child: Image.asset('assets/screen_images/loadingBar.gif'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
