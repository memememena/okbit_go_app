import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:okbit_go_app/utils/theme.dart';
import 'package:okbit_go_app/providers/navigation_provider.dart';
import 'home_screen.dart';
import 'community_screen.dart';
import 'school_life_screen.dart';
import 'events_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  static final Map<NavigationTab, Widget> _screens = {
    NavigationTab.home: const HomeScreen(),
    NavigationTab.community: const CommunityScreen(),
    NavigationTab.schoolLife: const SchoolLifeScreen(),
    NavigationTab.events: const EventsScreen(),
    NavigationTab.settings: const SettingsScreen(),
  };

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: DarkTheme.backgroundColor,
          body: IndexedStack(
            index: provider.currentIndex,
            children: _screens.values.toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: provider.currentIndex,
            onTap: provider.setIndex,
            backgroundColor: DarkTheme.backgroundColor,
            selectedItemColor: DarkTheme.textColor,
            unselectedItemColor: DarkTheme.unselectedColor,
            items: NavigationTab.values
                .map((tab) => BottomNavigationBarItem(
                      icon: Icon(tab.icon),
                      label: tab.label,
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
