import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';

class _ShellDestination {
  const _ShellDestination({
    required this.location,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String location;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const _destinations = [
  _ShellDestination(
    location: AppRoutes.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Home',
  ),
  _ShellDestination(
    location: AppRoutes.search,
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
    label: 'Search',
  ),
  _ShellDestination(
    location: AppRoutes.bookings,
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month,
    label: 'Booking',
  ),
  _ShellDestination(
    location: AppRoutes.profile,
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Profile',
  ),
];

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  int _currentIndex() {
    final cleanPath = location.split('?').first;
    
    if (cleanPath == AppRoutes.home) return 0;
    if (cleanPath == AppRoutes.search) return 1;
    if (cleanPath == AppRoutes.bookings) return 2;
    if (cleanPath == AppRoutes.profile) return 3;
    
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex() != 0) {
          context.go(AppRoutes.home);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          height: 70.h,
          selectedIndex: _currentIndex(),
          onDestinationSelected: (index) {
            context.go(_destinations[index].location);
          },
          destinations: _destinations
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
