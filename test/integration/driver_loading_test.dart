import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/location/position_reader.dart';
import 'package:mobile_app/core/nfc/nfc_reader.dart';
import 'package:mobile_app/core/utils/map_navigator.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart' as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart' as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_vehicle.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/vehicle_verification_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/tank_material.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

class _MockNfcReader extends Mock implements NfcReader {}

class _MockVerifyVehicle extends Mock implements VerifyVehicle {}

class _MockPositionReader extends Mock implements PositionReader {}

/// spec 008 T118 (US4): the driver's warehouse leg on the real
/// `DeliveryDetailScreen`.
///
/// The destination is the thing this stage exists to communicate. Before
/// spec 008 a driver went straight to the customer; now there is a leg in
/// between that the platform knows about and the driver does not, unless
/// this screen says so.
void main() {
  const warehouse = WarehouseSummary(
    name: 'Riyadh North Depot',
    addressText: 'Exit 9, Northern Ring Road',
    location: GeoPoint(lat: 24.7136, lng: 46.6753),
  );
  const tank = TankSummary(code: 'TNK-9921', material: TankMaterial.aluminium);

  Order orderAt(OrderStatus status) => Order(
    id: 'order-loading-leg',
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    tankSummary: tank,
    warehouseSummary: warehouse,
    clientSummary: const ClientSummary(fullName: 'Sara Al-Qahtani', phone: '+966511111111'),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  late List<Uri> launched;

  setUp(() {
    launched = [];
    MapNavigator.launcher = (uri) async {
      launched.add(uri);
      return true;
    };
    getIt.registerFactoryParam<OtpVerifyCubit, String, void>(
      (orderId, _) => OtpVerifyCubit(
        orderId: orderId,
        markArrived: _MockMarkArrived(),
        verifyArrivalOtp: _MockVerifyArrivalOtp(),
        requestDeliveryOtp: _MockRequestDeliveryOtp(),
        verifyDeliveryOtp: _MockVerifyDeliveryOtp(),
      ),
    );
    getIt.registerFactoryParam<VehicleVerificationCubit, String, void>((orderId, _) {
      final nfcReader = _MockNfcReader();
      when(() => nfcReader.isAvailable()).thenAnswer((_) async => true);
      when(() => nfcReader.stopSession()).thenAnswer((_) async {});
      final positionReader = _MockPositionReader();
      when(() => positionReader.currentFix()).thenAnswer(
        (_) async => const PositionFix(longitude: 46.6753, latitude: 24.7136),
      );
      return VehicleVerificationCubit(
        orderId: orderId,
        nfcReader: nfcReader,
        verifyVehicle: _MockVerifyVehicle(),
        positionReader: positionReader,
      );
    });
  });

  tearDown(() {
    getIt.unregister<OtpVerifyCubit>();
    getIt.unregister<VehicleVerificationCubit>();
    resetOrdersTestDi();
  });

  Future<void> pumpDetail(WidgetTester tester, Order order) async {
    registerOrdersTestDi(orders: [order]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: order.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a LOADING delivery names the depot as its destination', (tester) async {
    await pumpDetail(tester, orderAt(OrderStatus.loading));

    expect(find.text('Riyadh North Depot'), findsOneWidget);
    expect(find.text('Exit 9, Northern Ring Road'), findsOneWidget);
  });

  testWidgets('the tank\'s code and material are visible before loading begins (FR-033b)', (
    tester,
  ) async {
    // From assignment onward, not only at the depot — a driver who can see
    // the tank code before setting off is the only check the platform has
    // on a swapped trailer, which it cannot detect itself.
    await pumpDetail(tester, orderAt(OrderStatus.assignedToDriver));
    expect(find.text('TNK-9921'), findsOneWidget);
    expect(find.text('Aluminium'), findsOneWidget);
  });

  testWidgets('the depot is a destination, not just an address (FR-027)', (tester) async {
    await pumpDetail(tester, orderAt(OrderStatus.loading));

    await tester.tap(find.text('Navigate to the depot'));
    await tester.pumpAndSettle();

    // Navigation is by coordinate: a depot's name is not a searchable
    // address, and a near-miss search result is worse than none.
    expect(launched, hasLength(1));
    expect(launched.single.toString(), contains('24.7136'));
    expect(launched.single.toString(), contains('46.6753'));
  });

  testWidgets('routing switches to the customer once loading is confirmed (FR-032)', (
    tester,
  ) async {
    // The same screen, one status later: the depot leg is finished, so the
    // depot must stop being presented as where the driver is going.
    await pumpDetail(tester, orderAt(OrderStatus.inTransit));

    expect(find.text('Riyadh North Depot'), findsNothing);
    expect(find.text('Navigate to the depot'), findsNothing);
    // The customer's leg is what is offered now.
    expect(find.text('I Have Arrived'), findsOneWidget);
  });

  testWidgets('the customer leg is not offered while the delivery is still loading (FR-031)', (
    tester,
  ) async {
    await pumpDetail(tester, orderAt(OrderStatus.loading));
    expect(find.text('I Have Arrived'), findsNothing);
    expect(find.text('Request Delivery Code'), findsNothing);
  });
}
