import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/localization/translation_keys.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/entities/driver_standing.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_driver_summary.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_state.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_home_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockLocationStreamService extends Mock implements LocationStreamService {}

class _MockGetDriverSummary extends Mock implements GetDriverSummary {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

/// feature 013 FR-011: `DeliveryActive.streaming` had been computed and read
/// by nothing since spec 007 — a driver who refused the location permission
/// saw a completely normal delivery card while the platform received nothing.
void main() {
  late _MockGetActiveOrder getActiveOrder;
  late _MockLocationStreamService locationStream;
  late DeliveryCubit deliveryCubit;
  late DriverSummaryCubit summaryCubit;

  final order = Order(
    id: 'order-untracked-1',
    status: OrderStatus.inTransit,
    fuelType: FuelType.diesel,
    quantityLiters: 20000,
    etaMinutes: 35,
    clientSummary: const ClientSummary(
      fullName: 'Ahmed Al-Otaibi',
      phone: '+966500000000',
    ),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
    getActiveOrder = _MockGetActiveOrder();
    locationStream = _MockLocationStreamService();
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
    final getDriverSummary = _MockGetDriverSummary();
    when(getDriverSummary.call).thenAnswer(
      (_) async => const Right(
        DriverStanding(ratingCount: 0, deliveriesToday: 0, readyForWork: true),
      ),
    );
    summaryCubit = DriverSummaryCubit(getDriverSummary: getDriverSummary);
    when(getActiveOrder.call).thenAnswer((_) async => Right(order));
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

  testWidgets(
    'streaming:false renders the untracked state on the active delivery',
    (tester) async {
      when(locationStream.start).thenAnswer((_) async => false);
      await deliveryCubit.load();
      await pumpHome(tester);
      await tester.pump();

      expect(deliveryCubit.state, isA<DeliveryActive>());
      expect(find.text(DriverKeys.untrackedTitle.tr()), findsOneWidget);
    },
  );

  testWidgets('streaming:true does NOT render the untracked state', (
    tester,
  ) async {
    when(locationStream.start).thenAnswer((_) async => true);
    await deliveryCubit.load();
    await pumpHome(tester);
    await tester.pump();

    expect(deliveryCubit.state, isA<DeliveryActive>());
    expect(find.text(DriverKeys.untrackedTitle.tr()), findsNothing);
  });
}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}
