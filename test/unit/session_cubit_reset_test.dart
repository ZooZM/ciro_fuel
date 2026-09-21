import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/network/paginated_response.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_cubit.dart';
import 'package:mobile_app/features/auth/presentation/cubit/session_state.dart';
import 'package:mobile_app/features/invoices/domain/entities/credit_standing.dart';
import 'package:mobile_app/features/invoices/domain/repositories/invoices_repository.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_credit_standing.dart';
import 'package:mobile_app/features/invoices/domain/usecases/get_invoices.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/finance_cubit.dart';
import 'package:mobile_app/features/invoices/presentation/cubit/finance_state.dart';
import 'package:mobile_app/features/notifications/domain/entities/notifications_page.dart';
import 'package:mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mobile_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mobile_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:mobile_app/features/orders/domain/usecases/get_orders.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mobile_app/features/orders/presentation/cubit/orders_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockOrdersRepository extends Mock implements OrdersRepository {}

class _MockInvoicesRepository extends Mock implements InvoicesRepository {}

class _MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class _UnusedTokenStore extends Mock implements TokenStore {}

/// Never connected, so `onNotification` registration inside
/// [NotificationsCubit]'s constructor is a safe no-op — the same fake
/// `logout_flow_test.dart` uses for the identical reason.
class _OfflineTrackingSocket extends TrackingSocket {
  _OfflineTrackingSocket() : super(tokenStore: _UnusedTokenStore());
}

/// spec 005 T029: every list cubit registered as a session-lifetime
/// singleton (T028 — OrdersCubit, FinanceCubit, NotificationsCubit) MUST be
/// reset when the session ends, or a stale singleton would leak the
/// previous client's orders/balances/notifications into the next client's
/// first frame after an account switch on the same device.
///
/// `_registerCore`'s reactive `sessionCubit.stream.listen(...)` in
/// `injector.dart` is private, so this test cannot invoke it directly —
/// Dart's privacy is file-scoped. It instead re-establishes the identical
/// two-branch subscription shown there against real cubit instances
/// registered into the real [getIt] (the same pattern `logout_flow_test.dart`
/// and `auth_session_test.dart` already use), which verifies the CONTRACT
/// T028 established rather than merely re-running a copy of the production
/// code. If `injector.dart`'s listener is ever extended to clear a further
/// cubit, this test's listener — and its assertions — must be extended too.
void main() {
  late SessionCubit sessionCubit;
  late OrdersCubit ordersCubit;
  late FinanceCubit financeCubit;
  late NotificationsCubit notificationsCubit;

  setUp(() {
    sessionCubit = SessionCubit();

    final ordersRepository = _MockOrdersRepository();
    when(
      () => ordersRepository.getOrders(
        status: any(named: 'status'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((_) async => const Right(PaginatedResult(items: [], nextCursor: null)));
    ordersCubit = OrdersCubit(
      getOrders: GetOrders(ordersRepository),
      socket: _OfflineTrackingSocket(),
    );

    final invoicesRepository = _MockInvoicesRepository();
    when(
      () => invoicesRepository.getInvoices(
        method: any(named: 'method'),
        state: any(named: 'state'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer(
      (_) async => const Right(PaginatedResult(items: [], nextCursor: null)),
    );
    when(
      invoicesRepository.getCreditStanding,
    ).thenAnswer((_) async => const Right(CreditStanding()));
    financeCubit = FinanceCubit(
      getInvoices: GetInvoices(invoicesRepository),
      getCreditStanding: GetCreditStanding(invoicesRepository),
    );

    final notificationsRepository = _MockNotificationsRepository();
    when(
      () => notificationsRepository.getNotifications(
        unread: any(named: 'unread'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer(
      (_) async =>
          const Right(NotificationsPage(items: [], nextCursor: null, unreadCount: 0)),
    );
    notificationsCubit = NotificationsCubit(
      getNotifications: GetNotifications(notificationsRepository),
      markNotificationRead: MarkNotificationRead(notificationsRepository),
      markAllNotificationsRead: MarkAllNotificationsRead(notificationsRepository),
      socket: _OfflineTrackingSocket(),
    );

    getIt
      ..registerSingleton<SessionCubit>(sessionCubit)
      ..registerSingleton<OrdersCubit>(ordersCubit)
      ..registerSingleton<FinanceCubit>(financeCubit)
      ..registerSingleton<NotificationsCubit>(notificationsCubit);

    // Mirrors injector.dart's `_registerCore` SessionUnauthenticated branch.
    sessionCubit.stream.listen((state) {
      if (state is SessionUnauthenticated) {
        getIt<NotificationsCubit>().clear();
        getIt<OrdersCubit>().clear();
        getIt<FinanceCubit>().clear();
      }
    });
  });

  tearDown(() async {
    await getIt.reset();
    await sessionCubit.close();
    await ordersCubit.close();
    await financeCubit.close();
    await notificationsCubit.close();
  });

  test(
    'signing out resets OrdersCubit, FinanceCubit and NotificationsCubit to their initial loading state',
    () async {
      await ordersCubit.load();
      await financeCubit.load();
      await notificationsCubit.load();

      expect(ordersCubit.state, isA<OrdersLoaded>());
      expect(financeCubit.state, isA<FinanceLoaded>());
      expect(notificationsCubit.state, isA<NotificationsLoaded>());

      sessionCubit.signOut();
      await pumpEventQueue();

      expect(
        ordersCubit.state,
        isA<OrdersLoading>(),
        reason: 'a stale order list must not survive into the next session',
      );
      expect(
        financeCubit.state,
        isA<FinanceLoading>(),
        reason: 'a stale balance must not survive into the next session',
      );
      expect(
        notificationsCubit.state,
        isA<NotificationsLoading>(),
        reason: 'a stale notification list must not survive into the next session',
      );
    },
  );
}
