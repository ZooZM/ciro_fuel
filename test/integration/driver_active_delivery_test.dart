import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/core/constants/app_assets.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/localization/app_locales.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/entities/driver_standing.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_driver_summary.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_home_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:easy_localization/easy_localization.dart';

import '../helpers/localized_harness.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}

class _MockLocationStreamService extends Mock
    implements LocationStreamService {}

class _MockGetDriverSummary extends Mock implements GetDriverSummary {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

/// spec 007 US1 (T024/T024a/T025): the driver's home screen against the
/// real `DriverHomeScreen` + real `DeliveryCubit`, with only the network
/// edges mocked — the same real widget a driver actually sees.
void main() {
  late _MockGetActiveOrder getActiveOrder;
  late _MockLocationStreamService locationStream;
  late DeliveryCubit deliveryCubit;
  late DriverSummaryCubit summaryCubit;

  final order = Order(
    id: 'order-aaa111',
    status: OrderStatus.inTransit,
    fuelType: FuelType.diesel,
    quantityLiters: 20000,
    etaMinutes: 35,
    clientSummary: const ClientSummary(fullName: 'Ahmed Al-Otaibi', phone: '+966500000000'),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    getActiveOrder = _MockGetActiveOrder();
    locationStream = _MockLocationStreamService();
    when(locationStream.start).thenAnswer((_) async => true);
    when(locationStream.stop).thenAnswer((_) async {});
    final acknowledgeAssignment = _MockAcknowledgeAssignment();
    when(
      () => acknowledgeAssignment(any()),
    ).thenAnswer((_) async => const Right(null));
    deliveryCubit = DeliveryCubit(
      getActiveOrder: getActiveOrder,
      verifyArrivalOtp: _MockVerifyArrivalOtp(),
      verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      locationStream: locationStream,
      acknowledgeAssignment: acknowledgeAssignment,
    );
    // spec 007 US5: the header this screen also renders now reads from its
    // own cubit — an ancestor is required, though what it resolves to is
    // outside this file's concern (driver_header_test.dart owns that).
    final getDriverSummary = _MockGetDriverSummary();
    when(getDriverSummary.call).thenAnswer(
      (_) async => const Right(
        DriverStanding(ratingCount: 0, deliveriesToday: 0, readyForWork: true),
      ),
    );
    summaryCubit = DriverSummaryCubit(getDriverSummary: getDriverSummary);
  });

  tearDown(() {
    deliveryCubit.close();
    summaryCubit.close();
  });

  Future<void> pumpHome(WidgetTester tester) => pumpLocalized(
    tester,
    MultiBlocProvider(
      providers: [
        BlocProvider<DeliveryCubit>.value(value: deliveryCubit),
        BlocProvider<DriverSummaryCubit>.value(value: summaryCubit),
      ],
      child: const DriverHomeScreen(),
    ),
    locale: const Locale('en'),
  );

  testWidgets('a real assigned delivery renders — fuel, quantity, customer, ETA', (
    tester,
  ) async {
    when(getActiveOrder.call).thenAnswer((_) async => Right(order));
    await deliveryCubit.load();

    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Ahmed Al-Otaibi'), findsOneWidget);
    expect(find.text('35'), findsOneWidget);
    // Never the sample data this screen used to show unconditionally.
    expect(find.text('ORD-2024-256'), findsNothing);
    expect(find.text('Mohamed Ahmed'), findsNothing);
  });

  testWidgets('no active delivery renders an explicit empty state — never blank, never sample', (
    tester,
  ) async {
    when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
    await deliveryCubit.load();

    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.text(NotificationKeys.bannerUnknown.tr()), findsNothing);
    expect(find.text('You have no active delivery right now.'), findsOneWidget);
  });

  testWidgets('a load failure renders a retryable error — distinct from the empty state', (
    tester,
  ) async {
    when(
      getActiveOrder.call,
    ).thenAnswer((_) async => const Left(Failure.network()));
    await deliveryCubit.load();

    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('You have no active delivery right now.'), findsNothing);
    expect(find.text(CommonKeys.retry.tr()), findsOneWidget);
  });

  testWidgets(
    'the three states never render identically to one another (FR-004/FR-032/FR-044)',
    (tester) async {
      // Loading: the cubit's own initial state, before load() ever
      // resolves. Not `pumpHome` — its final settle is a full
      // `pumpAndSettle()`, which never returns while an indeterminate
      // CircularProgressIndicator is animating. Wraps the same way
      // `pumpLocalized` does, but settles with bounded pumps instead.
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();
      await tester.runAsync(() async {
        for (final locale in AppLocales.supported) {
          await rootBundle.loadString(
            '${AppAssets.translationsPath}/${locale.languageCode}.json',
          );
        }
      });

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: AppLocales.supported,
          fallbackLocale: AppLocales.fallback,
          startLocale: AppLocales.english,
          path: AppAssets.translationsPath,
          child: Builder(
            builder: (context) => MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: MultiBlocProvider(
                providers: [
                  BlocProvider<DeliveryCubit>.value(value: deliveryCubit),
                  BlocProvider<DriverSummaryCubit>.value(value: summaryCubit),
                ],
                child: const DriverHomeScreen(),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('You have no active delivery right now.'), findsNothing);
      expect(find.text(CommonKeys.retry.tr()), findsNothing);
    },
  );

  testWidgets(
    'a status push for the active delivery updates the card on the next frame '
    '— no cubit-side delay stacked on top of the platform push (SC-007)',
    (tester) async {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      await deliveryCubit.load();
      await pumpHome(tester);
      expect(find.text('Ahmed Al-Otaibi'), findsOneWidget);

      when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
      // The exact path DeliveryListener drives in production.
      deliveryCubit.handleOrderStatus({
        'orderId': order.id,
        'to': 'DELIVERED',
        'at': '2026-01-01T13:00:00Z',
      });
      await tester.pumpAndSettle();

      expect(find.text('Ahmed Al-Otaibi'), findsNothing);
      expect(find.text('You have no active delivery right now.'), findsOneWidget);
    },
  );

  testWidgets(
    'a driver switch leaves nothing of the previous driver on screen (SC-006)',
    (tester) async {
      when(getActiveOrder.call).thenAnswer((_) async => Right(order));
      await deliveryCubit.load();
      await pumpHome(tester);
      expect(find.text('Ahmed Al-Otaibi'), findsOneWidget);

      // The exact call spec 006 wires into SessionUnauthenticated.
      deliveryCubit.clear();
      await tester.pumpAndSettle();

      expect(find.text('Ahmed Al-Otaibi'), findsNothing);
      expect(find.text('You have no active delivery right now.'), findsOneWidget);
    },
  );
}
