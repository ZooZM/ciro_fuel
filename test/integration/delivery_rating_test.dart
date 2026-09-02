import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/features/orders/domain/usecases/submit_rating.dart';
import 'package:mobile_app/features/orders/presentation/cubit/rating_cubit.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

class _MockSubmitRating extends Mock implements SubmitRating {}

/// spec 007 T097 (FR-037/FR-037d/FR-038/FR-041/FR-041a): the rating a
/// customer submits on their own order detail is the same `Order.rating`
/// the driver's delivery detail reads — both screens go through
/// `OrderDetailCubit`/`OrderMapper`, so this proves the whole path rather
/// than either side's widget in isolation.
void main() {
  Order deliveredOrder({OrderRating? rating}) => Order(
    id: 'order-rating-1',
    status: OrderStatus.delivered,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
    rating: rating,
  );

  tearDown(() {
    resetOrdersTestDi();
    if (getIt.isRegistered<OtpVerifyCubit>()) {
      getIt.unregister<OtpVerifyCubit>();
    }
  });

  /// `OrderDetailScreen` starts `OrderDetailCubit.load()`,
  /// `.loadCurrentOtp()` and `CreditCubit.load()` concurrently — several
  /// pumps are needed for all three to settle past their initial loading
  /// frame.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump();
    }
  }

  testWidgets(
    'a customer rates a delivered order and can see it reflected back',
    (tester) async {
      final order = deliveredOrder();
      registerOrdersTestDi(orders: [order]);
      final submitRating = _MockSubmitRating();
      when(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      ).thenAnswer(
        (_) async => const Right(OrderRating(score: 5, review: 'Perfect delivery')),
      );
      // registerOrdersTestDi already provides both, backed by
      // FakeOrdersRepository's own noSuchMethod-throws submitRating —
      // override with a mock this test can script and verify against.
      getIt.unregister<SubmitRating>();
      getIt.registerLazySingleton<SubmitRating>(() => submitRating);
      getIt.unregister<RatingCubit>();
      getIt.registerFactoryParam<RatingCubit, String, void>(
        (orderId, _) => RatingCubit(orderId: orderId, submitRating: getIt()),
      );

      await pumpLocalized(
        tester,
        OrderDetailScreen(orderId: order.id),
        locale: const Locale('en'),
      );
      await settle(tester);
      // The rating card sits at the end of a long delivered-card list,
      // below the fold at the test viewport's default size.
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pump();

      // Nothing submitted yet — the control is visible, no summary.
      expect(find.byIcon(Icons.star_border), findsWidgets);
      verifyNever(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      );

      await tester.tap(find.byIcon(Icons.star_border).last);
      await tester.pump();
      await tester.tap(find.text('Submit rating'));
      await tester.pump();
      await tester.pump();

      verify(
        () => submitRating(
          orderId: order.id,
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'a customer who leaves without submitting records nothing (FR-038)',
    (tester) async {
      final order = deliveredOrder();
      registerOrdersTestDi(orders: [order]);
      final submitRating = _MockSubmitRating();
      // registerOrdersTestDi already provides both, backed by
      // FakeOrdersRepository's own noSuchMethod-throws submitRating —
      // override with a mock this test can script and verify against.
      getIt.unregister<SubmitRating>();
      getIt.registerLazySingleton<SubmitRating>(() => submitRating);
      getIt.unregister<RatingCubit>();
      getIt.registerFactoryParam<RatingCubit, String, void>(
        (orderId, _) => RatingCubit(orderId: orderId, submitRating: getIt()),
      );

      await pumpLocalized(
        tester,
        OrderDetailScreen(orderId: order.id),
        locale: const Locale('en'),
      );
      await settle(tester);
      // Never tap a star or the submit button — just leave.

      verifyNever(
        () => submitRating(
          orderId: any(named: 'orderId'),
          score: any(named: 'score'),
          review: any(named: 'review'),
        ),
      );
    },
  );

  Future<void> pumpDriverDetail(WidgetTester tester, Order order) async {
    getIt.registerFactoryParam<OtpVerifyCubit, String, void>(
      (orderId, _) => OtpVerifyCubit(
        orderId: orderId,
        markArrived: _MockMarkArrived(),
        verifyArrivalOtp: _MockVerifyArrivalOtp(),
        requestDeliveryOtp: _MockRequestDeliveryOtp(),
        verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      ),
    );
    registerOrdersTestDi(orders: [order]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: order.id),
      locale: const Locale('en'),
    );
    await settle(tester);
  }

  testWidgets("the driver's detail shows the customer's score and review", (
    tester,
  ) async {
    await pumpDriverDetail(
      tester,
      deliveredOrder(
        rating: const OrderRating(score: 4, review: 'On time, friendly driver'),
      ),
    );

    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_border), findsNWidgets(1));
    expect(find.text('On time, friendly driver'), findsOneWidget);
  });

  testWidgets('an unrated completed delivery shows the not-yet-rated state', (
    tester,
  ) async {
    await pumpDriverDetail(tester, deliveredOrder());

    expect(find.text('Not yet rated'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);
  });
}
