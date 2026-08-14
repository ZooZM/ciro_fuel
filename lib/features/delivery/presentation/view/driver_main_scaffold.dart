import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/driver_nav_bar.dart';
import '../../../../core/theme/theme_context.dart';

class DriverMainScaffold extends StatelessWidget {
  const DriverMainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _navBarLift = 10;
  static const double _navBarInset = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            bottom: MediaQuery.viewPaddingOf(context).bottom + _navBarLift,
            left: _navBarInset,
            right: _navBarInset,
            child: DriverNavBar(
              currentIndex: navigationShell.currentIndex,
              notificationCount: 3, // mock count from image
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
