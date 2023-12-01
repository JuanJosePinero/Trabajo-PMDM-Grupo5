import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/services/ElementService.dart';

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
                MaterialPageRoute(builder: (context) => EmotionCard()),
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

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late ElementService _elementService;
  List<ElementData> _elements = [];

  @override
  void initState() {
    super.initState();
    _elementService = ElementService();

    // Llama a getElements al iniciar
    _loadElements();
  }

  Future<void> _loadElements() async {
    try {
      ElementResponse response = await _elementService.getElements();
      setState(() {
        _elements = response.data ?? [];
      });
    } catch (error) {
      print('Error al cargar elementos: $error');
    }
  }

  Future<void> _refresh() async {
    await _loadElements();
  }

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
            RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: _elements.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: _getBackgroundColor(_elements[index].type),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: _getBorderColor(_elements[index].type),
                        width: 3.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Imagen a la izquierda
                          Image.asset(
                            'assets/screen_images/default_img.png',
                            fit: BoxFit.cover,
                            width: 80.0,
                            height: 80.0,
                          ),
                          const SizedBox(width: 16.0),
                          // Texto a la derecha
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _elements[index].name ?? '',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(_elements[index].description ?? ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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


Color _getBorderColor(String? elementType) {
  switch (elementType) {
    case 'mood':
      return Colors.yellow;
    case 'emotion':
      return Colors.red;
    case 'event':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color _getBackgroundColor(String? elementType) {
  switch (elementType) {
    case 'mood':
      return Colors.yellow[50] ?? Colors.transparent;
    case 'emotion':
      return Colors.red[50] ?? Colors.transparent;
    case 'event':
      return Colors.green[50] ?? Colors.transparent;
    default:
      return Colors.grey[50] ?? Colors.transparent;
  }
}
