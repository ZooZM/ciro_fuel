import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/entities/driver_standing.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_driver_summary.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_home_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/localized_harness.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}

class _MockLocationStreamService extends Mock implements LocationStreamService {}

class _MockGetDriverSummary extends Mock implements GetDriverSummary {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

/// spec 007 T081 (FR-031/SC-010): a never-rated driver's header must show
/// no numeral where the score would be, in both languages — the failure
/// mode this guards is a literal `0.0` silently standing in for "no
/// ratings yet", which reads to the driver as the platform's own worst
/// possible score of them.
void main() {
  late _MockGetActiveOrder getActiveOrder;
  late _MockGetDriverSummary getDriverSummary;
  late DeliveryCubit deliveryCubit;
  late DriverSummaryCubit summaryCubit;

  setUp(() {
    getActiveOrder = _MockGetActiveOrder();
    getDriverSummary = _MockGetDriverSummary();
    when(getActiveOrder.call).thenAnswer((_) async => const Right(null));
    final locationStream = _MockLocationStreamService();
    when(locationStream.stop).thenAnswer((_) async {});
    deliveryCubit = DeliveryCubit(
      getActiveOrder: getActiveOrder,
      verifyArrivalOtp: _MockVerifyArrivalOtp(),
      verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      locationStream: locationStream,
      acknowledgeAssignment: _MockAcknowledgeAssignment(),
    );
    summaryCubit = DriverSummaryCubit(getDriverSummary: getDriverSummary);
  });

  tearDown(() {
    deliveryCubit.close();
    summaryCubit.close();
  });

  Future<void> pumpHome(WidgetTester tester, Locale locale) async {
    await deliveryCubit.load();
    await summaryCubit.load();
    await pumpLocalized(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryCubit>.value(value: deliveryCubit),
          BlocProvider<DriverSummaryCubit>.value(value: summaryCubit),
        ],
        child: const DriverHomeScreen(),
      ),
      locale: locale,
    );
  }

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    testWidgets('a never-rated driver ($locale) shows no numeral for the score', (
      tester,
    ) async {
      when(getDriverSummary.call).thenAnswer(
        (_) async => const Right(
          DriverStanding(ratingCount: 0, deliveriesToday: 2, readyForWork: true),
        ),
      );
      await pumpHome(tester, locale);

      // No decimal-looking text anywhere — the failure mode this guards is
      // a literal `0.0` silently standing in for "no ratings yet".
      final decimalLikeText = find.byWidgetPredicate(
        (w) => w is Text && (w.data ?? '').contains('.') && (w.data ?? '').length <= 4,
      );
      expect(decimalLikeText, findsNothing);
      // The other figure (deliveries today) is unaffected and still a real number.
      expect(find.text('2'), findsOneWidget);
    });
  }

  testWidgets('a rated driver shows the real numeral', (tester) async {
    when(getDriverSummary.call).thenAnswer(
      (_) async => const Right(
        DriverStanding(
          ratingAverage: 4.7,
          ratingCount: 20,
          deliveriesToday: 1,
          readyForWork: true,
        ),
      ),
    );
    await pumpHome(tester, const Locale('en'));

    expect(find.text('4.7'), findsOneWidget);
  });
}
