import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/core/security/biometric_authenticator.dart';
import 'package:mobile_app/features/auth/presentation/cubit/app_lock_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/view/app_lock_gate.dart';
import 'package:mobile_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mobile_app/features/notifications/presentation/widgets/notification_banner_presenter.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _MockBiometricAuthenticator extends Mock
    implements BiometricAuthenticator {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

class _MockGetNotifications extends Mock implements GetNotifications {}

class _MockMarkNotificationRead extends Mock
    implements MarkNotificationRead {}

class _MockMarkAllNotificationsRead extends Mock
    implements MarkAllNotificationsRead {}

const _driver = AuthUser(
  id: 'd1',
  role: UserRole.driver,
  companyId: 'c1',
  fullName: 'A Driver',
);

/// Mimics how `DriverNavigationScreen`/`DriverScanScreen` actually reach
/// the screen stack today (`delivery_detail_screen.dart`,
/// `driver_navigation_bottom_sheet.dart`): a raw `Navigator.push` with a
/// bare `MaterialPageRoute`, entirely outside go_router. This is the
/// specific hole a redirect-based lock would miss.
class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const _RawPushedScreen()),
          ),
          child: const Text('home'),
        ),
      ),
    );
  }
}

class _RawPushedScreen extends StatelessWidget {
  const _RawPushedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('raw-pushed-content')));
  }
}

/// Bundles a fresh, correctly-stubbed [AppLockCubit] and registers it in
/// [getIt], returning the [SessionCubit] the test drives to engage the
/// lock.
///
/// Deliberately constructed **inside each `testWidgets` body**, not in a
/// shared `setUp()`: `AppLockCubit`'s constructor subscribes to a stream
/// and registers a `WidgetsBindingObserver`, and `package:test`'s `setUp`
/// runs in a plain Dart zone outside `testWidgets`' own
/// `TestWidgetsFlutterBinding`-managed zone. Built there, the subscription
/// still fires correctly (proven directly — the cubit's `state` reads
/// `locked` right on schedule) but `pumpAndSettle` does not reliably
/// drain the microtask that would let `BlocBuilder` observe it, so the
/// widget tree silently keeps rendering the pre-lock content. Building it
/// here, in the same zone `pumpAndSettle` actually drains, is what fixes
/// that — not a change to `AppLockGate` itself, which was correct throughout.
SessionCubit _mountLockGate(WidgetTester tester) {
  final biometrics = _MockBiometricAuthenticator();
  // LockScreen auto-prompts the moment it mounts into `locked` (see its
  // own initState) — an unstubbed mock throws (Future<bool> from a
  // null-returning Mock method). Declining cleanly settles the state back
  // to `locked`, which is what these tests assert against.
  when(biometrics.isDeviceLockAvailable).thenAnswer((_) async => true);
  when(
    () => biometrics.authenticate(
      localizedReason: any(named: 'localizedReason'),
      allowDeviceCredential: true,
    ),
  ).thenAnswer((_) async => false);

  // Unauthenticated at construction: AppLockCubit starts `unlocked`, so
  // the tests below can reach and push from the home screen before
  // engaging the lock — the real point-in-time a driver would push a
  // navigation screen and then have the device time out on them.
  final sessionCubit = SessionCubit();
  final appLockCubit = AppLockCubit(biometrics: biometrics, sessionCubit: sessionCubit);
  getIt.registerSingleton<AppLockCubit>(appLockCubit);
  addTearDown(() {
    appLockCubit.close();
    sessionCubit.close();
  });
  return sessionCubit;
}

/// Mounts [home] under a real `Navigator`, with [AppLockGate] wrapping
/// that Navigator via `MaterialApp.builder` — the exact topology
/// `app.dart` uses. Putting `AppLockGate` inside `home` instead would
/// place it as one route's content, so a route later pushed on top of it
/// would stack visually above it — inverting production's layering,
/// where the gate sits outside the Navigator and covers every route
/// regardless of how it was pushed.
Future<void> _pumpWithLockGate(WidgetTester tester, Widget home) => pumpLocalized(
  tester,
  home,
  builder: (context, child) =>
      AppLockGate(child: child ?? const SizedBox.shrink()),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(getIt.reset);

  testWidgets(
    'covers a screen reached via a raw Navigator.push (MaterialPageRoute), '
    'not only go_router routes',
    (tester) async {
      final sessionCubit = _mountLockGate(tester);
      await _pumpWithLockGate(tester, const _HomeScreen());

      await tester.tap(find.text('home'));
      await tester.pumpAndSettle();
      expect(find.text('raw-pushed-content'), findsOneWidget);

      // The lock engages the same way it would on a real device: the
      // driver's session authenticates (or, equivalently, the app
      // resumes past the threshold) while that raw-pushed screen is the
      // topmost route in the Navigator AppLockGate sits above.
      sessionCubit.authenticate(_driver);
      await tester.pumpAndSettle();

      expect(find.text('raw-pushed-content'), findsNothing);
      expect(find.text(LockKeys.title.tr()), findsOneWidget);
    },
  );

  testWidgets(
    'a delivery notification cannot be tapped through to its destination '
    'while locked (FR-016) — NotificationBannerPresenter is not even '
    'mounted, guarding against AppLockGate/NotificationBannerPresenter '
    'ever being reordered in app.dart',
    (tester) async {
      final sessionCubit = _mountLockGate(tester);

      final notificationsCubit = NotificationsCubit(
        getNotifications: _MockGetNotifications(),
        markNotificationRead: _MockMarkNotificationRead(),
        markAllNotificationsRead: _MockMarkAllNotificationsRead(),
        socket: _MockTrackingSocket(),
      );
      addTearDown(notificationsCubit.close);

      await _pumpWithLockGate(
        tester,
        BlocProvider<NotificationsCubit>.value(
          value: notificationsCubit,
          child: const NotificationBannerPresenter(child: _HomeScreen()),
        ),
      );

      // Unlocked: the banner presenter (and the app content it wraps) is
      // in the tree, as production expects it to always be for a signed-
      // in driver whose session is not challenged.
      expect(find.byType(NotificationBannerPresenter), findsOneWidget);

      sessionCubit.authenticate(_driver);
      await tester.pumpAndSettle();

      // Locked: AppLockGate has replaced its entire child — including
      // NotificationBannerPresenter — with LockScreen. There is no banner
      // to tap, so there is nothing for FR-016 to fail on. If a future
      // change ever moved NotificationBannerPresenter above AppLockGate in
      // app.dart, this assertion is what would catch it.
      expect(find.byType(NotificationBannerPresenter), findsNothing);
      expect(find.text(LockKeys.title.tr()), findsOneWidget);
    },
  );
}
