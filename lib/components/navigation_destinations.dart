import 'package:flutter/material.dart';

class AppNavigationDestination {
  const AppNavigationDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class AppNavigationDestinations {
  static const List<AppNavigationDestination> destinations = [
    AppNavigationDestination('Journal', Icon(Icons.book_outlined), Icon(Icons.book)),
    AppNavigationDestination('Calendar', Icon(Icons.calendar_today_outlined), Icon(Icons.calendar_today)),
    AppNavigationDestination('Search', Icon(Icons.search_outlined), Icon(Icons.search)),
    AppNavigationDestination('Profile', Icon(Icons.person_outline), Icon(Icons.person)),
    AppNavigationDestination('Settings', Icon(Icons.settings_outlined), Icon(Icons.settings)),
  ];
}
