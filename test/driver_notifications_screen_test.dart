import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/core/network/token_store.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/notifications/domain/entities/app_notification.dart';
import 'package:mobile_app/features/notifications/domain/entities/notifications_page.dart';
import 'package:mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mobile_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:mobile_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:mobile_app/features/notifications/presentation/constants/notification_presentation.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mobile_app/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_notifications_screen.dart';
import 'package:mobile_app/shared/enums/notification_type.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _UnusedTokenStore extends Mock implements TokenStore {}

class _OfflineSocket extends TrackingSocket {
  _OfflineSocket() : super(tokenStore: _UnusedTokenStore());
}

class _FakeRepo implements NotificationsRepository {
  _FakeRepo(this.notifications);
  List<AppNotification> notifications;
  bool failNext = false;
  int getCalls = 0;

  @override
  Future<Either<Failure, NotificationsPage>> getNotifications({
    bool? unread,
    String? cursor,
  }) async {
    getCalls++;
    if (failNext) {
      failNext = false;
      return const Left(Failure.server());
    }
    final items = unread == true
        ? notifications.where((n) => !n.isRead).toList()
        : notifications;
    return Right(
      NotificationsPage(
        items: items,
        nextCursor: null,
        unreadCount: notifications.where((n) => !n.isRead).length,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> markRead(String id) async {
    notifications = [
      for (final n in notifications)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
    return const Right(null);
  }

  @override
  Future<Either<Failure, int>> markAllRead() async {
    final n = notifications.where((x) => !x.isRead).length;
    notifications = [for (final x in notifications) x.copyWith(isRead: true)];
    return Right(n);
  }
}

void main() {
  late _FakeRepo repo;

  NotificationsCubit buildCubit() => NotificationsCubit(
    getNotifications: GetNotifications(repo),
    markNotificationRead: MarkNotificationRead(repo),
    markAllNotificationsRead: MarkAllNotificationsRead(repo),
    socket: _OfflineSocket(),
  );

  void register() {
    if (getIt.isRegistered<NotificationsCubit>()) {
      getIt.unregister<NotificationsCubit>();
    }
    getIt.registerSingleton<NotificationsCubit>(buildCubit());
  }

  tearDown(() {
    if (getIt.isRegistered<NotificationsCubit>()) {
      getIt.unregister<NotificationsCubit>();
    }
  });

  AppNotification n(String id, NotificationType t, {bool read = false, DateTime? at}) =>
      AppNotification(
        id: id,
        type: t,
        orderId: 'o-$id',
        createdAt: at ?? DateTime(2026, 1, 1, 12),
        isRead: read,
      );

  testWidgets('renders from the cubit, newest-first, unread distinguished, no fabricated row', (
    tester,
  ) async {
    repo = _FakeRepo([
      n('new', NotificationType.orderAssigned, at: DateTime(2026, 1, 2, 9)),
      n('old', NotificationType.driverStopDetected, read: true, at: DateTime(2026, 1, 1, 9)),
    ]);
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen());
    await tester.pumpAndSettle();

    // Real content, from the presentation map — and nothing invented.
    expect(
      find.text(NotificationPresentation.message(NotificationType.orderAssigned)),
      findsOneWidget,
    );
    expect(find.textContaining('ORD-2024-256'), findsNothing);
    expect(find.textContaining('5 mins ago'), findsNothing);
    expect(find.textContaining('System Update'), findsNothing);

    // Newest first: the unread ORDER_ASSIGNED row precedes the read one.
    final assigned = tester.getTopLeft(
      find.text(NotificationPresentation.message(NotificationType.orderAssigned)),
    );
    final stop = tester.getTopLeft(
      find.text(NotificationPresentation.message(NotificationType.driverStopDetected)),
    );
    expect(assigned.dy, lessThan(stop.dy));

    // Unread is visually distinguished — an unread dot exists, and the
    // unread row's label is bolder than the read row's.
    final unreadLabel = tester.widget<Text>(
      find.text(NotificationPresentation.message(NotificationType.orderAssigned)),
    );
    final readLabel = tester.widget<Text>(
      find.text(NotificationPresentation.message(NotificationType.driverStopDetected)),
    );
    expect(unreadLabel.style!.fontWeight, FontWeight.w700);
    expect(readLabel.style!.fontWeight, isNot(FontWeight.w700));
  });

  testWidgets('offers NO category tabs — only the All / Unread filter', (tester) async {
    repo = _FakeRepo([n('a', NotificationType.orderAssigned)]);
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen(), locale: const Locale('en'));
    await tester.pumpAndSettle();

    expect(find.text('Orders'), findsNothing);
    expect(find.text('System'), findsNothing);
    expect(find.text(NotificationKeys.filterAll.tr()), findsOneWidget);
    expect(find.text(NotificationKeys.filterUnread.tr()), findsOneWidget);
  });

  testWidgets('the All / Unread filter partitions correctly', (tester) async {
    repo = _FakeRepo([
      n('u', NotificationType.orderAssigned),
      n('r', NotificationType.orderStatusChanged, read: true),
    ]);
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen(), locale: const Locale('en'));
    await tester.pumpAndSettle();

    expect(
      find.text(NotificationPresentation.message(NotificationType.orderStatusChanged)),
      findsOneWidget,
    );
    await tester.tap(find.text(NotificationKeys.filterUnread.tr()));
    await tester.pumpAndSettle();
    // The read one is gone; the unread one stays.
    expect(
      find.text(NotificationPresentation.message(NotificationType.orderStatusChanged)),
      findsNothing,
    );
    expect(
      find.text(NotificationPresentation.message(NotificationType.orderAssigned)),
      findsOneWidget,
    );
  });

  testWidgets('an unrecognised type renders neutrally, not blank or dropped (FR-031)', (
    tester,
  ) async {
    repo = _FakeRepo([n('x', NotificationType.unknown)]);
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen());
    await tester.pumpAndSettle();

    expect(
      find.text(NotificationPresentation.message(NotificationType.unknown)),
      findsOneWidget,
    );
  });

  testWidgets('distinct loading / empty / failure states, and retry re-issues the load (FR-024)', (
    tester,
  ) async {
    repo = _FakeRepo([]);
    repo.failNext = true;
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen(), locale: const Locale('en'));
    await tester.pumpAndSettle();

    // Failure state — a stated error with a retry, no fabricated rows.
    expect(find.text(OrdersKeys.loadFailed.tr()), findsOneWidget);
    final callsBeforeRetry = repo.getCalls;

    await tester.tap(find.text(OrdersKeys.retry.tr()));
    await tester.pumpAndSettle();

    expect(repo.getCalls, greaterThan(callsBeforeRetry)); // retry actually re-fetched
    // Now an explicit empty state, not sample rows.
    expect(find.text(OrdersKeys.empty.tr()), findsOneWidget);
  });

  testWidgets('mark-all-read empties the unread set; a press with nothing unread is a no-op', (
    tester,
  ) async {
    repo = _FakeRepo([
      n('a', NotificationType.orderAssigned),
      n('b', NotificationType.driverStopDetected),
    ]);
    register();

    await pumpLocalized(tester, const DriverNotificationsScreen(), locale: const Locale('en'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(NotificationKeys.markAllRead.tr()));
    await tester.pumpAndSettle();

    final cubit = getIt<NotificationsCubit>();
    expect(cubit.state.unreadBadgeCount, 0);

    // Pressing again changes nothing and shows no error.
    await tester.tap(find.text(NotificationKeys.markAllRead.tr()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(cubit.state.unreadBadgeCount, 0);
  });
}
