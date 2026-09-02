import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/features/delivery/data/services/location_stream_service.dart';
import 'package:mobile_app/features/delivery/domain/entities/driver_standing.dart';
import 'package:mobile_app/features/delivery/domain/usecases/acknowledge_assignment.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_active_order.dart';
import 'package:mobile_app/features/delivery/domain/usecases/get_driver_summary.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart'
    as delivery;
import 'package:mobile_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/driver_summary_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_home_screen.dart';
import 'package:mobile_app/features/delivery/presentation/view/driver_orders_screen.dart';
import 'package:mobile_app/features/orders/presentation/view/order_detail_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

class _MockGetActiveOrder extends Mock implements GetActiveOrder {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

class _MockLocationStreamService extends Mock implements LocationStreamService {}

class _MockGetDriverSummary extends Mock implements GetDriverSummary {}

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockAcknowledgeAssignment extends Mock implements AcknowledgeAssignment {}

const _longName = 'محمد عبدالرحمن السيد العتيبي القحطاني الدوسري الشهراني';
const _longReview =
    'كانت التجربة ممتازة من البداية إلى النهاية، السائق كان في غاية '
    'الاحترافية والالتزام بالمواعيد، ووصل الوقود بالكمية المطلوبة بالضبط '
    'دون أي تأخير أو مشكلة، وأنصح بالتعامل مع هذه الخدمة مرة أخرى دون تردد.';

/// spec 007 T101 (FR-043/SC-008): the screens this feature rewired, pumped
/// under the default Arabic locale with a long customer name / long review
/// — the same class of bug spec 006's own RTL sweep already found twice on
/// sibling driver screens.
void main() {
  tearDown(resetOrdersTestDi);

  testWidgets('DriverHomeScreen renders under Arabic with a long customer name', (
    tester,
  ) async {
    final order = Order(
      id: 'order-rtl-1',
      status: OrderStatus.inTransit,
      fuelType: FuelType.diesel,
      quantityLiters: 20000,
      etaMinutes: 12,
      clientSummary: const ClientSummary(fullName: _longName, phone: '+966500000000'),
      statusChangedAt: DateTime.utc(2026, 1, 1, 12),
    );
    final getActiveOrder = _MockGetActiveOrder();
    when(getActiveOrder.call).thenAnswer((_) async => Right(order));
    final locationStream = _MockLocationStreamService();
    when(locationStream.start).thenAnswer((_) async => true);
    when(locationStream.stop).thenAnswer((_) async {});
    final acknowledgeAssignment = _MockAcknowledgeAssignment();
    when(
      () => acknowledgeAssignment(any()),
    ).thenAnswer((_) async => const Right(null));
    final deliveryCubit = DeliveryCubit(
      getActiveOrder: getActiveOrder,
      verifyArrivalOtp: _MockVerifyArrivalOtp(),
      verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      locationStream: locationStream,
      acknowledgeAssignment: acknowledgeAssignment,
    );
    final getDriverSummary = _MockGetDriverSummary();
    when(getDriverSummary.call).thenAnswer(
      (_) async => const Right(
        DriverStanding(ratingAverage: 4.9, ratingCount: 40, deliveriesToday: 3, readyForWork: true),
      ),
    );
    final summaryCubit = DriverSummaryCubit(getDriverSummary: getDriverSummary);
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
    );

    expect(tester.takeException(), isNull);
    await deliveryCubit.close();
    await summaryCubit.close();
  });

  testWidgets('DriverOrdersScreen renders under Arabic with long destinations', (
    tester,
  ) async {
    registerOrdersTestDi(
      orders: [
        for (final status in [
          OrderStatus.inTransit,
          OrderStatus.delivered,
          OrderStatus.cancelled,
        ])
          Order(
            id: 'order-rtl-list-${status.name}',
            status: status,
            fuelType: FuelType.diesel,
            quantityLiters: 15000,
            deliveryAddressText:
                'جدة - حي الروضة - شارع الأمير سلطان - مجمع الأبراج التجاري رقم 42',
            statusChangedAt: DateTime.utc(2026, 1, 1, 12),
          ),
      ],
    );

    await pumpLocalized(tester, const DriverOrdersScreen());

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'DeliveryDetailScreen renders under Arabic with a long customer name and review',
    (tester) async {
      final order = Order(
        id: 'order-rtl-detail-1',
        status: OrderStatus.delivered,
        fuelType: FuelType.diesel,
        quantityLiters: 500,
        clientSummary: const ClientSummary(fullName: _longName, phone: '+966500000000'),
        statusChangedAt: DateTime.utc(2026, 1, 1, 12),
        rating: const OrderRating(score: 5, review: _longReview),
      );
      registerOrdersTestDi(orders: [order]);
      getIt.registerFactoryParam<OtpVerifyCubit, String, void>(
        (orderId, _) => OtpVerifyCubit(
          orderId: orderId,
          markArrived: _MockMarkArrived(),
          verifyArrivalOtp: _MockVerifyArrivalOtp(),
          requestDeliveryOtp: _MockRequestDeliveryOtp(),
          verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
        ),
      );

      await pumpLocalized(tester, DeliveryDetailScreen(orderId: order.id));
      for (var i = 0; i < 4; i++) {
        await tester.pump();
      }

      expect(tester.takeException(), isNull);
      if (getIt.isRegistered<OtpVerifyCubit>()) {
        getIt.unregister<OtpVerifyCubit>();
      }
    },
  );

  testWidgets(
    "the client's rating control renders under Arabic with a long review already given",
    (tester) async {
      final order = Order(
        id: 'order-rtl-rating-1',
        status: OrderStatus.delivered,
        fuelType: FuelType.diesel,
        quantityLiters: 500,
        statusChangedAt: DateTime.utc(2026, 1, 1, 12),
        rating: const OrderRating(score: 4, review: _longReview),
      );
      registerOrdersTestDi(orders: [order]);

      await pumpLocalized(tester, OrderDetailScreen(orderId: order.id));
      for (var i = 0; i < 4; i++) {
        await tester.pump();
      }
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );
}
