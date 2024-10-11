import 'package:flutter/material.dart';

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);
  final String initialLocation;
}

class NavigationDestinationTabItem extends NavigationDestination {
  final String initialLocation;

  const NavigationDestinationTabItem(
      {required this.initialLocation,
        super.key,
      required super.icon,
      required super.label,
      super.selectedIcon,
      super.tooltip});
}
