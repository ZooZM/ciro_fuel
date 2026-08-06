import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/main_nav_bar.dart';

class ClientMainScaffold extends StatelessWidget {
  const ClientMainScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8), // Match _kBackground
      body: Stack(
        children: [
          // The currently active tab screen
          Positioned.fill(
            child: navigationShell,
          ),
          
          // Persistent Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MainNavBar(
              currentIndex: navigationShell.currentIndex,
              notificationCount: 3, // Keep the notification count as it was
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  // Support navigating to the initial location when tapping the item that is already active
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
