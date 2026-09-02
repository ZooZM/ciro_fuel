import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/core/location/position_reader.dart';
import 'package:mobile_app/core/nfc/nfc_reader.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_vehicle.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/vehicle_verification_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/vehicle_verification_state.dart';
import 'package:mobile_app/shared/entities/order.dart';
import 'package:mobile_app/shared/enums/fuel_type.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mobile_app/shared/enums/verification_method.dart';
import 'package:mocktail/mocktail.dart';

class _MockNfcReader extends Mock implements NfcReader {}

class _MockVerifyVehicle extends Mock implements VerifyVehicle {}

class _MockPositionReader extends Mock implements PositionReader {}

void main() {
  late _MockNfcReader nfcReader;
  late _MockVerifyVehicle verifyVehicle;
  late _MockPositionReader positionReader;

  /// The depot gate, as the phone reports it at the moment of the tap.
  const fix = PositionFix(longitude: 46.6753, latitude: 24.7136);

  const orderId = 'order-1';
  final verifiedOrder = Order(
    id: orderId,
    status: OrderStatus.loading,
    fuelType: FuelType.diesel,
    quantityLiters: 500,
    statusChangedAt: DateTime(2026),
  );

  setUp(() {
    nfcReader = _MockNfcReader();
    verifyVehicle = _MockVerifyVehicle();
    positionReader = _MockPositionReader();
    when(() => positionReader.currentFix()).thenAnswer((_) async => fix);
    // blocTest closes the cubit after every case, which calls this —
    // stubbed here so it doesn't need repeating in each test's own setUp.
    when(() => nfcReader.stopSession()).thenAnswer((_) async {});
  });

  VehicleVerificationCubit build() => VehicleVerificationCubit(
    orderId: orderId,
    nfcReader: nfcReader,
    verifyVehicle: verifyVehicle,
    positionReader: positionReader,
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'checkAvailability reflects the reader, never assumes availability',
    setUp: () => when(() => nfcReader.isAvailable()).thenAnswer((_) async => true),
    build: build,
    act: (cubit) => cubit.checkAvailability(),
    expect: () => const [VehicleVerificationState.idle(nfcAvailable: true)],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'nfcAvailable == false is reported plainly, never as a failure',
    setUp: () => when(() => nfcReader.isAvailable()).thenAnswer((_) async => false),
    build: build,
    act: (cubit) => cubit.checkAvailability(),
    expect: () => const [VehicleVerificationState.idle(nfcAvailable: false)],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'a tapped card that matches submits the raw tag id and reflects the returned order',
    setUp: () {
      when(() => nfcReader.readTagId()).thenAnswer((_) async => 'CARD-123');
      when(
        () => verifyVehicle(
          orderId: orderId,
          credential: 'CARD-123',
          method: VerificationMethod.nfcCard,
          driverLocation: any(named: 'driverLocation'),
        ),
      ).thenAnswer((_) async => Right(verifiedOrder));
    },
    build: build,
    act: (cubit) => cubit.readTagAndVerify(),
    expect: () => [
      const VehicleVerificationState.reading(),
      const VehicleVerificationState.submitting(),
      VehicleVerificationState.verified(verifiedOrder),
    ],
    verify: (_) => verify(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'CARD-123',
        method: VerificationMethod.nfcCard,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).called(1),
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'a cancelled/timed-out read (no tag) returns quietly to idle — not a refusal',
    setUp: () => when(() => nfcReader.readTagId()).thenAnswer((_) async => null),
    build: build,
    act: (cubit) => cubit.readTagAndVerify(),
    expect: () => const [
      VehicleVerificationState.reading(),
      VehicleVerificationState.idle(nfcAvailable: true),
    ],
    verify: (_) => verifyZeroInteractions(verifyVehicle),
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'a scanned QR code submits the raw scanned value, distinct from the card path',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'QR-XYZ',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer((_) async => Right(verifiedOrder)),
    build: build,
    act: (cubit) => cubit.verifyCode('QR-XYZ'),
    expect: () => [
      const VehicleVerificationState.submitting(),
      VehicleVerificationState.verified(verifiedOrder),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'VEHICLE_MISMATCH is a distinct outcome, never generic failure',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'WRONG',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer(
      (_) async => const Left(Failure.validation('mismatch', code: 'VEHICLE_MISMATCH')),
    ),
    build: build,
    act: (cubit) => cubit.verifyCode('WRONG'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.mismatch(),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'a network failure is reported as unreachable — nothing was recorded (FR-021)',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'ANY',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer((_) async => const Left(Failure.network())),
    build: build,
    act: (cubit) => cubit.verifyCode('ANY'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.failure(unreachable: true),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'an out-of-sequence rejection (409, no recognised code) is a plain failure, not a mismatch',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'ANY',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer((_) async => const Left(Failure.validation('out of sequence'))),
    build: build,
    act: (cubit) => cubit.verifyCode('ANY'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.failure(),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'the 6th attempt in the window is throttled, distinct from a mismatch or a failure',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'ANY',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer(
      (_) async => const Left(Failure.throttled(retryAfter: Duration(minutes: 15))),
    ),
    build: build,
    act: (cubit) => cubit.verifyCode('ANY'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.throttled(retryAfter: Duration(minutes: 15)),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'the fix taken at the moment of the read travels with the attempt (FR-030c)',
    setUp: () {
      when(() => nfcReader.readTagId()).thenAnswer((_) async => 'CARD-123');
      when(
        () => verifyVehicle(
          orderId: orderId,
          credential: 'CARD-123',
          method: VerificationMethod.nfcCard,
          driverLocation: any(named: 'driverLocation'),
        ),
      ).thenAnswer((_) async => Right(verifiedOrder));
    },
    build: build,
    act: (cubit) => cubit.readTagAndVerify(),
    verify: (_) => verify(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'CARD-123',
        method: VerificationMethod.nfcCard,
        driverLocation: fix,
      ),
    ).called(1),
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'a device with no fix still submits — the stage, and whether it needed one, '
    'is the platform\'s call (research R7)',
    setUp: () {
      when(() => positionReader.currentFix()).thenAnswer((_) async => null);
      when(
        () => verifyVehicle(
          orderId: orderId,
          credential: 'QR-XYZ',
          method: VerificationMethod.qrCode,
          driverLocation: any(named: 'driverLocation'),
        ),
      ).thenAnswer((_) async => Right(verifiedOrder));
    },
    build: build,
    act: (cubit) => cubit.verifyCode('QR-XYZ'),
    verify: (_) => verify(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'QR-XYZ',
        method: VerificationMethod.qrCode,
        driverLocation: null,
      ),
    ).called(1),
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'NOT_AT_WAREHOUSE keeps the measured distance, so the driver is told how far short '
    'they are (FR-030a)',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'CARD-123',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        Failure.validation(
          'not at warehouse',
          code: 'NOT_AT_WAREHOUSE',
          extra: {'distanceMeters': 4321, 'radiusMeters': 500},
        ),
      ),
    ),
    build: build,
    act: (cubit) => cubit.verifyCode('CARD-123'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.notAtWarehouse(distanceMeters: 4321),
    ],
  );

  blocTest<VehicleVerificationCubit, VehicleVerificationState>(
    'LOCATION_REQUIRED is its own outcome — the phone needs fixing, not the truck '
    'and not the driving (FR-030c)',
    setUp: () => when(
      () => verifyVehicle(
        orderId: orderId,
        credential: 'CARD-123',
        method: VerificationMethod.qrCode,
        driverLocation: any(named: 'driverLocation'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        Failure.validation('location required', code: 'LOCATION_REQUIRED'),
      ),
    ),
    build: build,
    act: (cubit) => cubit.verifyCode('CARD-123'),
    expect: () => const [
      VehicleVerificationState.submitting(),
      VehicleVerificationState.locationUnavailable(),
    ],
  );

  test(
    'no VehicleVerificationState variant ever carries a credential (FR-022/FR-042): '
    'toString() of every variant is free of the submitted value',
    () {
      const states = [
        VehicleVerificationState.idle(nfcAvailable: true),
        VehicleVerificationState.reading(),
        VehicleVerificationState.submitting(),
        VehicleVerificationState.mismatch(),
        VehicleVerificationState.throttled(retryAfter: Duration(minutes: 15)),
        VehicleVerificationState.notAtWarehouse(distanceMeters: 4321),
        VehicleVerificationState.locationUnavailable(),
        VehicleVerificationState.failure(),
      ];
      for (final state in states) {
        expect(state.toString(), isNot(contains('CARD-123')));
        expect(state.toString(), isNot(contains('QR-XYZ')));
      }
    },
  );
}
