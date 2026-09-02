import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../cubit/app_lock_cubit.dart';
import '../cubit/app_lock_state.dart';
import 'lock_screen.dart';

/// Renders [LockScreen] over everything whenever `AppLockCubit` is not in
/// [AppLockUnlocked] (spec 006 US2).
///
/// Installed in `app.dart`'s `MaterialApp.router builder:`, **not** a
/// `go_router` redirect. That distinction is load-bearing, not stylistic:
/// `DriverNavigationScreen` and `DriverScanScreen` are pushed with raw
/// `MaterialPageRoute` (`delivery_detail_screen.dart`,
/// `driver_navigation_bottom_sheet.dart`), bypassing go_router entirely. A
/// redirect only runs when go_router itself decides where to navigate, so
/// it would never see those pushes and would leave both screens reachable
/// behind a lock that believes it is holding. `builder:` sits above the
/// `Navigator` those raw pushes still go through, so it covers every
/// screen regardless of how it was routed to.
class AppLockGate extends StatelessWidget {
  const AppLockGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppLockCubit>.value(
      value: getIt<AppLockCubit>(),
      child: BlocBuilder<AppLockCubit, AppLockState>(
        builder: (context, state) => switch (state) {
          AppLockUnlocked() => child,
          AppLockLocked() ||
          AppLockAuthenticating() ||
          AppLockUnavailable() => const LockScreen(),
        },
      ),
    );
  }
}
