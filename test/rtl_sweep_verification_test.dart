import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/location/position_reader.dart';
import 'package:mobile_app/core/nfc/nfc_reader.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart' as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart' as delivery;
import 'package:mobile_app/features/delivery/domain/usecases/verify_vehicle.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/vehicle_verification_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/view/delivery_detail_screen.dart';
import 'package:mobile_app/features/delivery/presentation/view/vehicle_verification_screen.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/entities/value_objects.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/tank_material.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/localized_harness.dart';
import 'support/orders_test_di.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

class _MockNfcReader extends Mock implements NfcReader {}

class _MockVerifyVehicle extends Mock implements VerifyVehicle {}

class _MockPositionReader extends Mock implements PositionReader {}

/// spec 008 T136: the screens this feature added, pumped under the default
/// Arabic locale with realistically long content.
///
/// The equivalent sweep found two real overflow bugs in specs 006 and 007,
/// which is why it is a standing task rather than a one-off: Arabic copy
/// runs longer than the English it was laid out against, and a depot's real
/// address is a sentence, not a label.
void main() {
  // A real Aramco depot name and address run far longer than the fixture
  // strings a developer lays a card out against.
  const longWarehouseName = 'مستودع أرامكو السعودية للتوزيع — المنطقة الصناعية الثانية بالرياض';
  const longAddress =
      'طريق الملك عبدالعزيز الفرعي، مخرج ٩، بجوار محطة التوزيع الرئيسية، '
      'المنطقة الصناعية الثانية، الرياض ١٤٣٢٥، المملكة العربية السعودية';
  // Tank codes are operator-entered and globally unique, so they drift long.
  const longTankCode = 'TNK-RUH-2026-ALU-0099821-A';

  Order orderAt(OrderStatus status) => Order(
    id: 'order-rtl-verification',
    status: status,
    fuelType: FuelType.diesel,
    quantityLiters: 20000,
    tankSummary: const TankSummary(code: longTankCode, material: TankMaterial.aluminium),
    warehouseSummary: const WarehouseSummary(
      name: longWarehouseName,
      addressText: longAddress,
      location: GeoPoint(lat: 24.7136, lng: 46.6753),
    ),
    clientSummary: const ClientSummary(
      fullName: 'محمد عبدالرحمن السيد العتيبي القحطاني الدوسري',
      phone: '+966500000000',
    ),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  setUp(() {
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

  testWidgets('the LOADING delivery screen survives a long depot name and address', (
    tester,
  ) async {
    // Without the real font, text falls back to a much wider test face and
    // reports overflows the app would never hit.
    await loadTajawal();
    registerOrdersTestDi(orders: [orderAt(OrderStatus.loading)]);

    await pumpLocalized(tester, DeliveryDetailScreen(orderId: 'order-rtl-verification'));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    // It genuinely rendered the depot block — an early-returning error state
    // would also throw no exception.
    expect(find.textContaining('مستودع أرامكو'), findsOneWidget);
  });

  testWidgets('the tank row survives a long code alongside its material', (tester) async {
    await loadTajawal();
    registerOrdersTestDi(orders: [orderAt(OrderStatus.assignedToDriver)]);

    await pumpLocalized(tester, DeliveryDetailScreen(orderId: 'order-rtl-verification'));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    // The code and the material sit in a two-column row, so a long code is
    // exactly where that row would break.
    expect(find.text(longTankCode), findsOneWidget);
  });

  testWidgets('the verification screen renders in Arabic at both stages', (tester) async {
    await loadTajawal();
    for (final isLoadingStage in [false, true]) {
      registerOrdersTestDi(orders: [orderAt(OrderStatus.loading)]);
      await pumpLocalized(
        tester,
        VehicleVerificationScreen(
          orderId: 'order-rtl-verification',
          isLoadingStage: isLoadingStage,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull, reason: 'loading stage: $isLoadingStage');
    }
  });

  testWidgets('the screen is laid out right-to-left under Arabic', (tester) async {
    await loadTajawal();
    registerOrdersTestDi(orders: [orderAt(OrderStatus.loading)]);

    await pumpLocalized(tester, DeliveryDetailScreen(orderId: 'order-rtl-verification'));
    await tester.pump();
    await tester.pump();

    // Arabic is the default locale, so this is the direction the majority
    // of real sessions run in — not an edge case being accommodated.
    final directionality = tester.widget<Directionality>(
      find.ancestor(of: find.byType(Scaffold).first, matching: find.byType(Directionality)).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
