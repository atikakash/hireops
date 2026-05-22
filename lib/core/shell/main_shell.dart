import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../router/app_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = [
    (
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: AppStrings.dashboard,
      path: AppRoutes.dashboard
    ),
    (
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: AppStrings.candidates,
      path: AppRoutes.candidates
    ),
    (
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: AppStrings.jobs,
      path: AppRoutes.jobs
    ),
    (
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: AppStrings.activity,
      path: AppRoutes.activity
    ),
    (
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: AppStrings.settings,
      path: AppRoutes.settings
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: t.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
