import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/main_nav_bar.dart';
import '../../../../core/theme/theme_context.dart';

class ClientMainScaffold extends StatelessWidget {
  const ClientMainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Gap between the bar and the system inset below it.
  static const double _navBarLift = 10;

  /// Side margin, so the bar reads as floating rather than as a footer.
  static const double _navBarInset = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas, // Match context.colors.canvas
      body: Stack(
        children: [
          // The currently active tab screen
          Positioned.fill(child: navigationShell),

          // Persistent Bottom Navigation Bar.
          //
          // Floated clear of the screen edge: sat flush at the bottom it ran
          // under the phone's own gesture bar / navigation buttons, which draw
          // on top of it. `viewPadding` is the system inset — unlike
          // `padding` it stays put when the keyboard is up, so the bar does
          // not jump.
          Positioned(
            bottom: MediaQuery.viewPaddingOf(context).bottom + _navBarLift,
            left: _navBarInset,
            right: _navBarInset,
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
