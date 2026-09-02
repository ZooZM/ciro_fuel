import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/session_revocation_listener.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/shared/entities/auth_user.dart';
import 'package:mobile_app/shared/enums/user_role.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../helpers/localized_harness.dart';

const _driver = AuthUser(
  id: 'driver-1',
  role: UserRole.driver,
  companyId: 'company-1',
  fullName: 'Test Driver',
);

class _FakeSecureStoragePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterSecureStoragePlatform {}

class _MockTrackingSocket extends Mock implements TrackingSocket {}

/// spec 006 US5 (T084): the two ways a driver's live session can end
/// without their own action — the primary `session:revoked` push (FR-035)
/// and the handshake-refusal fallback for a device that was offline when it
/// went out (FR-035a) — must both land the driver on the login screen with
/// a cause-specific message (FR-036), never the server's raw `message` text
/// (Principle I/III).
///
/// Exercises the real `SessionRevocationListener` production wiring
/// (`injector.dart` calls this exact class) against a mocked
/// [TrackingSocket] whose registered callbacks are captured and invoked
/// directly — a live `/tracking` socket server has no test double in this
/// suite, so this is the seam production code and this test genuinely
/// share.
void main() {
  late Map<String, String> backingStorage;
  late TokenStore tokenStore;
  late SessionCubit sessionCubit;
  late _MockTrackingSocket trackingSocket;
  late void Function(Map<String, dynamic>) revokedHandler;
  late void Function(dynamic) connectErrorHandler;

  setUp(() async {
    backingStorage = {};
    final storagePlatform = _FakeSecureStoragePlatform();
    when(
      () => storagePlatform.read(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((i) async => backingStorage[i.namedArguments[#key] as String]);
    when(
      () => storagePlatform.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((i) async {
      backingStorage[i.namedArguments[#key] as String] =
          i.namedArguments[#value] as String;
    });
    when(
      () => storagePlatform.delete(
        key: any(named: 'key'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (i) async => backingStorage.remove(i.namedArguments[#key] as String),
    );
    FlutterSecureStoragePlatform.instance = storagePlatform;

    tokenStore = TokenStore();
    await tokenStore.save(access: 'access-1', refresh: 'refresh-1');
    sessionCubit = SessionCubit();
    sessionCubit.authenticate(_driver);
    trackingSocket = _MockTrackingSocket();

    when(
      () => trackingSocket.onSessionRevoked(captureAny()),
    ).thenAnswer((invocation) {
      revokedHandler =
          invocation.positionalArguments.first
              as void Function(Map<String, dynamic>);
    });
    when(() => trackingSocket.onConnectError(captureAny())).thenAnswer((
      invocation,
    ) {
      connectErrorHandler =
          invocation.positionalArguments.first as void Function(dynamic);
    });

    SessionRevocationListener(
      trackingSocket: trackingSocket,
      tokenStore: tokenStore,
      sessionCubit: sessionCubit,
    ).attach();
  });

  testWidgets(
    'a session:revoked push clears the local session and states the specific cause',
    (tester) async {
      await pumpLocalized(tester, const Text('x'), locale: const Locale('en'));

      revokedHandler({
        'cause': 'ACCOUNT_DEACTIVATED',
        'occurredAt': '2026-01-01T00:00:00Z',
      });
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));

      expect(await tokenStore.accessToken, isNull);
      final state = sessionCubit.state;
      expect(state, isA<SessionUnauthenticated>());
      expect(
        (state as SessionUnauthenticated).reason,
        SessionKeys.accountDeactivated.tr(),
      );
    },
  );

  testWidgets(
    'a connect_error carrying UNAUTHORIZED does the same, with the generic fallback message',
    (tester) async {
      await pumpLocalized(tester, const Text('x'), locale: const Locale('en'));

      connectErrorHandler('Error: UNAUTHORIZED');
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));

      expect(await tokenStore.accessToken, isNull);
      final state = sessionCubit.state;
      expect(state, isA<SessionUnauthenticated>());
      expect((state as SessionUnauthenticated).reason, SessionKeys.ended.tr());
    },
  );

  testWidgets(
    'a connect_error unrelated to auth does NOT sign the driver out (an ordinary connectivity blip)',
    (tester) async {
      await pumpLocalized(tester, const Text('x'), locale: const Locale('en'));

      connectErrorHandler('xhr poll error');
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));

      expect(await tokenStore.accessToken, 'access-1');
      expect(sessionCubit.state, isA<SessionAuthenticated>());
    },
  );
}
