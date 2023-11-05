import 'package:flutter/material.dart';

class ThemeColors {
  static LinearGradient getGradient() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 236, 197, 252),
        Color.fromARGB(255, 225, 207, 255),
        Color.fromARGB(255, 169, 198, 255),
        Color.fromARGB(255, 114, 191, 255),
      ],
    );
  }

}
