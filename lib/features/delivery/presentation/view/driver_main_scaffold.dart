import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/driver_nav_bar.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';

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
              // spec 006 FR-009: the driver's actual unread count, not a
              // fixed mock — same source the client shell already reads.
              notificationCount: context
                  .watch<NotificationsCubit>()
                  .state
                  .unreadBadgeCount,
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
