import 'package:flutter/material.dart';

enum NavigationTab {
  home(0, '홈', Icons.home),
  community(1, '커뮤니티', Icons.group),
  schoolLife(2, '학교생활', Icons.school),
  events(3, '이벤트', Icons.event),
  settings(4, '설정', Icons.settings);

  final int tabIndex;
  final String label;
  final IconData icon;

  const NavigationTab(this.tabIndex, this.label, this.icon);

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.home,
    );
  }
}

class NavigationProvider extends ChangeNotifier {
  NavigationTab _currentTab = NavigationTab.home;

  NavigationTab get currentTab => _currentTab;
  int get currentIndex => _currentTab.tabIndex;

  void setTab(NavigationTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void setIndex(int index) {
    final tab = NavigationTab.fromIndex(index);
    setTab(tab);
  }

  void goToTab(BuildContext context, NavigationTab tab) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
    setTab(tab);
  }
}
