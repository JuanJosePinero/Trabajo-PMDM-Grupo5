import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/themeColors.dart';
import '../admin/customAppBar.dart';
import 'cards/emotion_card.dart';
import 'cards/event_card.dart';
import 'cards/mood_card.dart';

class _FloatingActionButtonGroup extends StatefulWidget {
  @override
  _FloatingActionButtonGroupState createState() =>
      _FloatingActionButtonGroupState();
}

class _FloatingActionButtonGroupState
    extends State<_FloatingActionButtonGroup> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isExpanded)
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmotionCard()),
              );
            },
            tooltip: 'Emotions',
            heroTag: null,
            icon: const Icon(Icons.lightbulb),
            label: 'Emotions',
          ),
        if (_isExpanded)
          const SizedBox(
            height: 16,
          ),
        if (_isExpanded)
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodCard()),
              );
            },
            tooltip: 'Mood',
            heroTag: null,
            icon: const Icon(Icons.emoji_emotions),
            label: 'Mood',
          ),
        if (_isExpanded)
          const SizedBox(
            height: 16,
          ),
        if (_isExpanded)
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventCard()),
              );
            },
            tooltip: 'Events',
            heroTag: null,
            icon: const Icon(Icons.star),
            label: 'Events',
          ),
        const SizedBox(
          height: 16,
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          tooltip: 'Toggle buttons',
          heroTag: null,
          child: _isExpanded ? const Icon(Icons.close) : const Icon(Icons.add),
        ),
      ],
    );
  }
}

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: Stack(
          children: [
            // Lista de tarjetas en un ListView
            ListView(
              children: [],
            ),

            Positioned(
              bottom: 80.0,
              right: 20.0,
              child: _FloatingActionButtonGroup(),
            ),
          ],
        ),
      ),
    );
  }
}
