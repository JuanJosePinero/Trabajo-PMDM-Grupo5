import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class MindFulnessScreen extends StatelessWidget {
  const MindFulnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
      ),
    );
  }
}
