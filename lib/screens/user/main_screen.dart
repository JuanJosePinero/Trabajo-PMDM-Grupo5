import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/user/cards/emotion_card.dart';
import 'package:mindcare_app/screens/user/cards/event_card.dart';
import 'package:mindcare_app/screens/user/cards/mood_card.dart';
import 'package:mindcare_app/screens/user/diary_screen.dart';

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
    print(title);
    if (title == 'Diary') {
      return const DiaryScreen();
    } else if (title == 'Profile') {
      print('Hol?!!?!');
    } else {
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
      );
    }

    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Text('Page under construction'),
      ),
    );
  }
}
