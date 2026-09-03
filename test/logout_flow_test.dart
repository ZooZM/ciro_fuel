import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
// `Localization` and `Translations` are what `.tr()` reads from, but
// easy_localization only re-exports the widget that populates them. Seeding
// them directly is the only way to translate a tree the EasyLocalization
// widget is not wrapped around.
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/router/app_routes.dart';
import 'package:mobile_app/core/theme/theme_cubit.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/usecases/sign_out.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/features/more/presentation/view/client_more_screen.dart';
import 'package:mobile_app/features/notifications/domain/entities/app_notification.dart';
import 'package:mobile_app/features/notifications/domain/entities/notifications_page.dart';
import 'package:mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mobile_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mobile_app/features/stations/domain/entities/station.dart';
import 'package:mobile_app/features/stations/domain/repositories/stations_repository.dart';
import 'package:mobile_app/features/stations/domain/usecases/get_stations.dart';
import 'package:mobile_app/features/stations/domain/usecases/set_favourite_station.dart';
import 'package:mobile_app/features/stations/presentation/cubit/stations_cubit.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/notification_type.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _MockStationsRepository extends Mock implements StationsRepository {}

/// Two stations, so the profile header's count is a value that could only
/// have come from the repository — a hardcoded `1` would fail this.
final _stations = [
  Station(
    id: 's1',
    name: 'Main depot',
    regionCode: 'R1',
    governorateCode: 'G1',
    location: const GeoPoint(lat: 24.7, lng: 46.6),
    addressText: 'Riyadh',
    isDefault: true,
    isFavourite: false,
  ),
  Station(
    id: 's2',
    name: 'North yard',
    regionCode: 'R1',
    governorateCode: 'G1',
    location: const GeoPoint(lat: 24.8, lng: 46.7),
    addressText: 'Riyadh',
    isDefault: false,
    isFavourite: true,
  ),
];

/// Never connected, so every `_socket?.…` call inside [TrackingSocket] is a
/// no-op — enough for a cubit that only registers a push handler on it.
class _OfflineTrackingSocket extends TrackingSocket {
  _OfflineTrackingSocket() : super(tokenStore: _UnusedTokenStore());
}

class _UnusedTokenStore extends Mock implements TokenStore {}

const _user = AuthUser(
  id: 'u1',
  role: UserRole.client,
  companyId: 'c1',
  fullName: 'Jane Client',
);

void main() {
  late _MockAuthRepository repository;
  late SessionCubit sessionCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The settings list draws its copy from `assets/translations/*.json` —
    // without it every row, including the logout button this file taps,
    // would render a raw key.
    final arabic = await const RootBundleAssetLoader().load(
      AppAssets.translationsPath,
      AppLocales.arabic,
    );
    Localization.load(AppLocales.arabic, translations: Translations(arabic));
  });

  setUp(() {
    repository = _MockAuthRepository();
    sessionCubit = SessionCubit()..authenticate(_user);

    // The screen resolves both from getIt (not from an inherited provider), so
    // the sign-out still lands if the router tears the screen down mid-await.
    final stationsRepository = _MockStationsRepository();
    when(stationsRepository.getStations).thenAnswer(
      (_) async => Right(_stations),
    );

    getIt
      ..registerSingleton<SessionCubit>(sessionCubit)
      ..registerSingleton<SignOut>(SignOut(repository))
      // The profile header now reads its station count from here (FR-036).
      ..registerFactory<StationsCubit>(
        () => StationsCubit(
          getStations: GetStations(stationsRepository),
          setFavouriteStation: SetFavouriteStation(stationsRepository),
        ),
      );
  });

  tearDown(() async {
    await getIt.reset();
    await sessionCubit.close();
  });

  Future<void> pumpMoreScreen(WidgetTester tester) async {
    final themeCubit = ThemeCubit();
    addTearDown(themeCubit.close);

    // Tall view: the logout button sits at the bottom of a long settings list,
    // and `tester.tap` refuses to hit an off-screen widget.
    tester.view.physicalSize = const Size(1206, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Pumped through a router, not a bare MaterialApp: the screen reads
    // `context.locale` (which needs a real EasyLocalization ancestor, not just
    // a seeded catalogue) and calls `context.go` once the sign-out lands.
    final router = GoRouter(
      initialLocation: AppRoutes.clientMore,
      routes: [
        GoRoute(
          path: AppRoutes.clientMore,
          // The screen's theme toggle reads ThemeCubit from an ancestor
          // provider, as app.dart supplies in production.
          builder: (_, _) => BlocProvider<ThemeCubit>.value(
            value: themeCubit,
            child: const ClientMoreScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const Scaffold(body: Text('login')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await pumpLocalizedRouter(tester, router);
  }

  Finder logoutButton() => find.widgetWithText(InkWell, 'تسجيل الخروج');

  testWidgets('asks for confirmation before signing out', (tester) async {
    await pumpMoreScreen(tester);

    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('سيتم إنهاء جلستك على هذا الجهاز. هل تريد المتابعة؟'), findsOneWidget);

    // Nothing has happened yet — the dialog is a question, not a side effect.
    verifyNever(repository.signOut);
    expect(sessionCubit.state, isA<SessionAuthenticated>());
  });

  testWidgets('cancelling leaves the session and the stored tokens untouched', (
    tester,
  ) async {
    await pumpMoreScreen(tester);

    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'إلغاء'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    verifyNever(repository.signOut);
    expect(sessionCubit.state, isA<SessionAuthenticated>());
  });

  testWidgets('confirming clears the tokens, then drops the session', (
    tester,
  ) async {
    // Captured synchronously at the instant the tokens are cleared. Observing
    // the order via `sessionCubit.stream` instead would prove nothing: a Cubit
    // delivers to its stream asynchronously, so the session event would always
    // *appear* to arrive second no matter what the code actually did.
    SessionState? sessionWhenTokensCleared;
    when(repository.signOut).thenAnswer((_) async {
      sessionWhenTokensCleared = sessionCubit.state;
    });

    await pumpMoreScreen(tester);

    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'تسجيل الخروج'));
    // `pump`, not `pumpAndSettle`: in production the router redirects to
    // /login and disposes this screen, but nothing does that in isolation, so
    // the logging-out spinner keeps animating and would never settle.
    await tester.pump();

    verify(repository.signOut).called(1);
    expect(sessionCubit.state, isA<SessionUnauthenticated>());
    // Deliberate sign-out carries no `reason` — that copy is reserved for an
    // involuntary expiry surfaced by AuthInterceptor.
    expect((sessionCubit.state as SessionUnauthenticated).reason, isNull);

    // Order matters: tokens gone BEFORE the router can react to the session
    // drop, so there is never a window where the app looks signed out while a
    // usable refresh token is still on disk.
    expect(
      sessionWhenTokensCleared,
      isA<SessionAuthenticated>(),
      reason: 'tokens must be cleared while the session is still live',
    );
  });

  testWidgets('still ends the session when clearing the tokens throws', (
    tester,
  ) async {
    // A locked Keychain/Keystore can fail the delete. Being signed out with
    // stale tokens on disk is strictly safer than being trapped in an
    // authenticated UI — and the next launch re-validates via /auth/me anyway.
    when(repository.signOut).thenThrow(Exception('secure storage unavailable'));

    await pumpMoreScreen(tester);

    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'تسجيل الخروج'));
    // `pump`, not `pumpAndSettle`: the spinner is up (the screen stays in its
    // logging-out state, since nothing here tears it down) and would never settle.
    await tester.pump();

    expect(sessionCubit.state, isA<SessionUnauthenticated>());
    // The failure is swallowed rather than thrown out of the tap handler —
    // an unhandled async error here would be a crash report, not a fix.
    expect(tester.takeException(), isNull);
  });

  testWidgets('a second tap cannot fire a second sign-out while one is in flight', (
    tester,
  ) async {
    // Held open so the first sign-out is still awaiting when the second tap
    // lands — the real-world double-tap.
    final gate = Completer<void>();
    when(repository.signOut).thenAnswer((_) => gate.future);

    await pumpMoreScreen(tester);

    await tester.tap(logoutButton().last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'تسجيل الخروج'));
    // Plain `pump`, never `pumpAndSettle`, while the sign-out is in flight:
    // the spinner animates indefinitely, so settling would time out.
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(logoutButton().last, warnIfMissed: false);
    await tester.pump();

    gate.complete();
    await tester.pump();

    verify(repository.signOut).called(1);
  });

  test('signing out clears the previous user notifications', () async {
    // NotificationsCubit is an app-lifetime singleton, so its state survives a
    // sign-out; without clearing, the next account on this device would see
    // the previous one's notifications until its own load() resolved.
    final notificationsRepository = _MockNotificationsRepository();
    when(
      () => notificationsRepository.getNotifications(
        unread: any(named: 'unread'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer(
      (_) async => Right(
        NotificationsPage(
          items: [
            AppNotification(
              id: 'n1',
              type: NotificationType.orderApprovedFinalPrice,
              orderId: 'o1',
              createdAt: DateTime.utc(2026, 5, 2),
            ),
          ],
          nextCursor: null,
          unreadCount: 1,
        ),
      ),
    );

    final cubit = NotificationsCubit(
      getNotifications: GetNotifications(notificationsRepository),
      markNotificationRead: MarkNotificationRead(notificationsRepository),
      markAllNotificationsRead: MarkAllNotificationsRead(notificationsRepository),
      socket: _OfflineTrackingSocket(),
    );
    addTearDown(cubit.close);

    await cubit.load();
    expect(cubit.state, isA<NotificationsLoaded>());

    cubit.clear();

    // Back to `loading`, not an empty `loaded`: nothing has been fetched for
    // whoever signs in next, and "no notifications yet" is a different claim.
    expect(cubit.state, isA<NotificationsLoading>());
  });
}
