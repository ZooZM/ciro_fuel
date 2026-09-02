import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import '../helpers/localized_harness.dart';
import '../support/orders_test_di.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyArrivalOtp extends Mock implements delivery.VerifyArrivalOtp {}

class _MockVerifyDeliveryOtp extends Mock implements delivery.VerifyDeliveryOtp {}

class _MockNfcReader extends Mock implements NfcReader {}

class _MockVerifyVehicle extends Mock implements VerifyVehicle {}

class _MockPositionReader extends Mock implements PositionReader {}

/// spec 008 T117 — **the absence test** (FR-028, SC-005a).
///
/// FR-028 is satisfied by code that does not exist: there is no quantity
/// field on any loading screen, and no DTO on the platform to receive one.
/// Nothing but a test keeps it that way, and the pressure to add one is
/// real and reasonable-sounding — a driver who can see the gauge will
/// eventually be asked to type what it says.
///
/// The reason not to is not UI minimalism. The authoritative volume comes
/// from an Aramco invoice reconciled later; a driver-entered figure would
/// look equally authoritative on screen while being an estimate, and would
/// silently become the number someone bills against.
void main() {
  final loadingOrder = Order(
    id: 'order-loading-1',
    status: OrderStatus.loading,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    tankSummary: const TankSummary(code: 'TNK-9921', material: TankMaterial.aluminium),
    warehouseSummary: const WarehouseSummary(
      name: 'Riyadh North Depot',
      addressText: 'Exit 9, Northern Ring Road',
      location: GeoPoint(lat: 24.7136, lng: 46.6753),
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
    for (final unregister in [
      () => getIt.unregister<OtpVerifyCubit>(),
      () => getIt.unregister<VehicleVerificationCubit>(),
    ]) {
      unregister();
    }
    resetOrdersTestDi();
  });

  /// Every editable or numeric affordance Flutter offers. Checking for
  /// `TextField` alone would miss a `TextFormField`, a `CupertinoTextField`,
  /// a `Slider`, or a `Stepper` — each of which is a plausible way for a
  /// quantity to arrive on this screen later.
  void expectNoQuantityInput(String where) {
    expect(find.byType(TextField), findsNothing, reason: 'TextField on $where');
    expect(find.byType(TextFormField), findsNothing, reason: 'TextFormField on $where');
    expect(find.byType(EditableText), findsNothing, reason: 'EditableText on $where');
    expect(find.byType(Slider), findsNothing, reason: 'Slider on $where');
    expect(find.byType(Stepper), findsNothing, reason: 'Stepper on $where');

    // A numeric keyboard is the tell-tale even if the field type changes.
    for (final field in find.byType(EditableText).evaluate()) {
      final widget = field.widget as EditableText;
      expect(
        widget.keyboardType,
        isNot(anyOf(TextInputType.number, const TextInputType.numberWithOptions())),
        reason: 'numeric keyboard on $where',
      );
    }
  }

  testWidgets('the driver\'s LOADING screen offers no quantity input (FR-028)', (tester) async {
    registerOrdersTestDi(orders: [loadingOrder]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: loadingOrder.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();

    // The screen really did render the loading stage — otherwise this test
    // would pass trivially against an error or empty state.
    expect(find.text('Riyadh North Depot'), findsOneWidget);
    expectNoQuantityInput('the LOADING delivery screen');
  });

  testWidgets('the verification screen offers no quantity input, at either stage (FR-028)', (
    tester,
  ) async {
    for (final isLoadingStage in [false, true]) {
      registerOrdersTestDi(orders: [loadingOrder]);
      await pumpLocalized(
        tester,
        VehicleVerificationScreen(orderId: loadingOrder.id, isLoadingStage: isLoadingStage),
        locale: const Locale('en'),
      );
      await tester.pump();

      expectNoQuantityInput('the verification screen (loading=$isLoadingStage)');
    }
  });

  testWidgets('confirming loading is a button, not a form (FR-028)', (tester) async {
    registerOrdersTestDi(orders: [loadingOrder]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: loadingOrder.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();

    // There is an action, and it takes no input. Both halves matter: a
    // screen with no action at all would also pass the assertions above.
    expect(find.byType(FilledButton), findsWidgets);
    expectNoQuantityInput('the loading confirmation');
  });

  testWidgets('no screen in the flow shows a litre figure the driver could be asked to match', (
    tester,
  ) async {
    registerOrdersTestDi(orders: [loadingOrder]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: loadingOrder.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();

    // The ORDERED quantity may legitimately appear — it is what the customer
    // asked for. What must never appear is a second, loaded figure beside
    // it, which is the shape a driver-entered volume would take.
    final texts = find
        .byType(Text)
        .evaluate()
        .map((e) => (e.widget as Text).data ?? '')
        .toList();
    final litreMentions = texts.where((t) => t.toLowerCase().contains('litre') || t.contains('L'));
    for (final mention in litreMentions) {
      expect(
        mention.contains('500') || !RegExp(r'\d').hasMatch(mention),
        isTrue,
        reason: 'unexpected volume figure "$mention" on the loading screen',
      );
    }
  });
}
