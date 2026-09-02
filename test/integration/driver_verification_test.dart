import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/di/injector.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/location/position_reader.dart';
import 'package:mobile_app/core/network/error_codes.dart';
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
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/verification_method.dart';
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

/// spec 008 T104 (US3, SC-010): the driver's side of the gate.
///
/// SC-010 requires a driver to tell the refusal causes apart *without
/// contacting support*. That is a UI guarantee, not a protocol one — the
/// platform already returns distinct codes, and this is the test that they
/// reach the driver as distinct sentences rather than being collapsed into
/// one "verification failed" by a well-meaning error handler.
///
/// Each cause sends the driver somewhere different: check the truck, drive
/// further, change a phone setting, or simply retry. A shared message would
/// send all four to the wrong place.
void main() {
  final assignedOrder = Order(
    id: 'order-verify-1',
    status: OrderStatus.assignedToDriver,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    clientSummary: const ClientSummary(fullName: 'Sara Al-Qahtani', phone: '+966511111111'),
    statusChangedAt: DateTime.utc(2026, 1, 1, 12),
  );

  late _MockVerifyVehicle verifyVehicle;
  late _MockNfcReader nfcReader;

  setUpAll(() {
    // mocktail needs a concrete value to stand in for `any(named: 'method')`
    // on a non-nullable enum parameter.
    registerFallbackValue(VerificationMethod.nfcCard);
  });

  setUp(() {
    verifyVehicle = _MockVerifyVehicle();
    nfcReader = _MockNfcReader();
    when(() => nfcReader.isAvailable()).thenAnswer((_) async => true);
    when(() => nfcReader.stopSession()).thenAnswer((_) async {});
    when(() => nfcReader.readTagId()).thenAnswer((_) async => 'CARD-TAPPED');

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
      final positionReader = _MockPositionReader();
      when(() => positionReader.currentFix()).thenAnswer(
        (_) async => const PositionFix(longitude: 46.6753, latitude: 24.7136),
      );
      return VehicleVerificationCubit(
        orderId: orderId,
        nfcReader: nfcReader,
        verifyVehicle: verifyVehicle,
        positionReader: positionReader,
      );
    });
  });

  tearDown(() {
    getIt.unregister<OtpVerifyCubit>();
    getIt.unregister<VehicleVerificationCubit>();
    resetOrdersTestDi();
  });

  void stubResult(Either<Failure, Order> result) {
    when(
      () => verifyVehicle(
        orderId: any(named: 'orderId'),
        credential: any(named: 'credential'),
        method: any(named: 'method'),
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer((_) async => result);
  }

  Future<void> pumpVerification(WidgetTester tester) async {
    registerOrdersTestDi(orders: [assignedOrder]);
    await pumpLocalized(
      tester,
      VehicleVerificationScreen(orderId: assignedOrder.id, isLoadingStage: false),
      locale: const Locale('en'),
    );
    await tester.pump();
  }

  Future<void> tapCard(WidgetTester tester) async {
    await tester.tap(find.text('Tap NFC card'));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('an unverified delivery offers verification and nothing else (FR-020)', (
    tester,
  ) async {
    registerOrdersTestDi(orders: [assignedOrder]);
    await pumpLocalized(
      tester,
      DeliveryDetailScreen(orderId: assignedOrder.id),
      locale: const Locale('en'),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Verify vehicle'), findsOneWidget);
    // Every later step of the journey stays off the screen entirely —
    // not merely disabled, which would still suggest the driver could
    // proceed without verifying.
    expect(find.text('I Have Arrived'), findsNothing);
    expect(find.text('Request Delivery Code'), findsNothing);
    expect(find.text('Confirm loading complete'), findsNothing);
  });

  testWidgets('a mismatch is retryable and leaves the stage visibly unchanged', (tester) async {
    stubResult(const Left(Failure.validation('mismatch', code: ErrorCodes.vehicleMismatch)));
    await pumpVerification(tester);
    await tapCard(tester);

    expect(find.text("This isn't the assigned vehicle. Check the truck and try again."), findsOneWidget);
    // Still offering the tap: a refusal is not a dead end, and a driver who
    // walked to the right truck must be able to try immediately.
    expect(find.text('Tap NFC card'), findsOneWidget);

    // And a retry that succeeds goes through — the screen is not latched.
    stubResult(Right(assignedOrder));
    await tapCard(tester);
    expect(find.text("This isn't the assigned vehicle. Check the truck and try again."), findsNothing);
  });

  group('the refusal causes render distinguishably (SC-010, FR-037)', () {
    final cases = <String, (Either<Failure, Order>, String)>{
      'wrong vehicle': (
        const Left(Failure.validation('m', code: ErrorCodes.vehicleMismatch)),
        "This isn't the assigned vehicle. Check the truck and try again.",
      ),
      'not at the depot': (
        const Left(
          Failure.validation(
            'far',
            code: ErrorCodes.notAtWarehouse,
            extra: {'distanceMeters': 4300},
          ),
        ),
        'You are 4.3 km from the loading depot. Tap the card again once you arrive.',
      ),
      'location unavailable': (
        const Left(Failure.validation('loc', code: ErrorCodes.locationRequired)),
        "Location is off, so loading can't be verified. Turn on location for CIRO and try again.",
      ),
      'platform unreachable': (
        const Left(Failure.network()),
        "Couldn't reach the platform — nothing was recorded. Try again.",
      ),
      'throttled': (
        const Left(Failure.throttled(retryAfter: Duration(minutes: 15))),
        'Too many attempts. Wait a few minutes and try again.',
      ),
    };

    for (final entry in cases.entries) {
      testWidgets('${entry.key} says so in its own words', (tester) async {
        stubResult(entry.value.$1);
        await pumpVerification(tester);
        await tapCard(tester);

        expect(find.text(entry.value.$2), findsOneWidget);
      });
    }

    testWidgets('no two causes produce the same sentence', (tester) async {
      Set<String> screenText() => find
          .byType(Text)
          .evaluate()
          .map((e) => (e.widget as Text).data ?? '')
          .where((t) => t.isNotEmpty)
          .toSet();

      // What the screen says before any attempt — the static copy every
      // render shares. Diffing against it identifies the message without
      // guessing at its wording, which is what makes this a collapse
      // detector rather than a restatement of the case table above.
      stubResult(Right(assignedOrder));
      await pumpVerification(tester);
      final baseline = screenText();

      final rendered = <String, String>{};
      for (final entry in cases.entries) {
        stubResult(entry.value.$1);
        await pumpVerification(tester);
        await tapCard(tester);

        final appeared = screenText().difference(baseline);
        expect(appeared, isNotEmpty, reason: '${entry.key} rendered no message at all');
        rendered[entry.key] = (appeared.toList()..sort()).join('|');
      }

      expect(
        rendered.values.toSet(),
        hasLength(cases.length),
        reason: 'two refusal causes collapsed into one message: $rendered',
      );
    });

    testWidgets('an unreachable platform says nothing was recorded (FR-021)', (tester) async {
      stubResult(const Left(Failure.network()));
      await pumpVerification(tester);
      await tapCard(tester);

      // A driver who believes a failed attempt counted will not retry, and
      // will sit at the truck waiting for a state change that never comes.
      expect(find.textContaining('nothing was recorded'), findsOneWidget);
    });
  });

  testWidgets('the distance is dropped when it is inside GPS\'s own error bar', (tester) async {
    stubResult(
      const Left(
        Failure.validation(
          'far',
          code: ErrorCodes.notAtWarehouse,
          extra: {'distanceMeters': 40},
        ),
      ),
    );
    await pumpVerification(tester);
    await tapCard(tester);

    // "You are 0.0 km away" is worse than saying nothing — it reads as a
    // bug to the driver standing in the yard.
    expect(
      find.text('You are too far from the loading depot. Tap the card again once you arrive.'),
      findsOneWidget,
    );
  });

  testWidgets('a cancelled tap is not a refusal — it says nothing at all', (tester) async {
    when(() => nfcReader.readTagId()).thenAnswer((_) async => null);
    await pumpVerification(tester);
    await tapCard(tester);

    // No tag was ever presented, so there is nothing to refuse. Showing an
    // error here would train drivers to ignore the error area.
    verifyNever(
      () => verifyVehicle(
        orderId: any(named: 'orderId'),
        credential: any(named: 'credential'),
        method: any(named: 'method'),
        driverLocation: any(named: 'driverLocation'),
      ),
    );
    for (final message in [
      "This isn't the assigned vehicle. Check the truck and try again.",
      "Verification isn't available right now. Try again.",
    ]) {
      expect(find.text(message), findsNothing);
    }
  });

  testWidgets('the verification submits the tag it read, never one of its own (FR-022)', (
    tester,
  ) async {
    stubResult(Right(assignedOrder));
    await pumpVerification(tester);
    await tapCard(tester);

    // The cubit is a courier, not a judge: it passes the raw read straight
    // through and reflects whatever the platform decides.
    verify(
      () => verifyVehicle(
        orderId: assignedOrder.id,
        credential: 'CARD-TAPPED',
        method: VerificationMethod.nfcCard,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).called(1);
  });
}
