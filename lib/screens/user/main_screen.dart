import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/user/cards/emotion_card.dart';
import 'package:mindcare_app/screens/user/cards/event_card.dart';
import 'package:mindcare_app/screens/user/cards/mood_card.dart';

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabInfo = [
      const _TabInfo(
        'Diary',
        CupertinoIcons.book_circle,
      ),
      const _TabInfo(
        'Profile',
        CupertinoIcons.profile_circled,
      ),
      const _TabInfo(
        'Settings',
        CupertinoIcons.settings,
      ),
    ];

    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: CupertinoTabScaffold(
        restorationId: 'cupertino_tab_scaffold',
        tabBar: CupertinoTabBar(
          items: [
            for (final tabInfo in tabInfo)
              BottomNavigationBarItem(
                label: tabInfo.title,
                icon: Icon(tabInfo.icon),
              ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            restorationScopeId: 'cupertino_tab_view_$index',
            builder: (context) => _CupertinoDemoTab(
              title: tabInfo[index].title,
              icon: tabInfo[index].icon,
            ),
            defaultTitle: tabInfo[index].title,
          );
        },
      ),
    );
  }
}

class _CupertinoDemoTab extends StatelessWidget {
  const _CupertinoDemoTab({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      backgroundColor: CupertinoColors.systemBackground,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  semanticLabel: title,
                  size: 100,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70.0,
            right: 20.0,
            child: _FloatingActionButtonGroup(),
          ),
        ],
      ),
    );
  }
}

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
          _CustomFloatingActionButton(
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
          _CustomFloatingActionButton(
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
          _CustomFloatingActionButton(
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

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.tooltip,
    required this.heroTag,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String tooltip;
  final Object? heroTag;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          heroTag: heroTag,
          child: icon,
        ),
        const SizedBox(height: 1),
        Text(
        label,
        style: const TextStyle(fontSize: 12), // Ajusta el tamaño del texto según tus preferencias
      ),
      ],
    );
  }
}
