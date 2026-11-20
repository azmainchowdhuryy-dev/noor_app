import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import 'hadis_dua_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'tasbih_screen.dart';

/// ৪-ট্যাব Bottom Navigation। নতুন ট্যাব লাগলে এখানেই যোগ হবে।
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onOpenTab: _goToTab),
      const HadisDuaScreen(),
      const TasbihScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goToTab,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: context.tr('home')),
          NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: context.tr('hadis_dua')),
          NavigationDestination(
              icon: const Icon(Icons.touch_app_outlined),
              selectedIcon: const Icon(Icons.touch_app),
              label: context.tr('tasbih')),
          NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              selectedIcon: const Icon(Icons.more_horiz),
              label: context.tr('more')),
        ],
      ),
    );
  }
}
