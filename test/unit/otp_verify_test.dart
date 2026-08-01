import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/error/failure.dart';
import 'package:mobile_app/features/delivery/domain/usecases/mark_arrived.dart';
import 'package:mobile_app/features/delivery/domain/usecases/request_delivery_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_arrival_otp.dart';
import 'package:mobile_app/features/delivery/domain/usecases/verify_delivery_otp.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_cubit.dart';
import 'package:mobile_app/features/delivery/presentation/cubit/otp_verify_state.dart';
import 'package:mobile_app/shared/enums/order_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockMarkArrived extends Mock implements MarkArrived {}

class _MockVerifyArrivalOtp extends Mock implements VerifyArrivalOtp {}

class _MockRequestDeliveryOtp extends Mock implements RequestDeliveryOtp {}

class _MockVerifyDeliveryOtp extends Mock implements VerifyDeliveryOtp {}

void main() {
  late _MockMarkArrived markArrived;
  late _MockVerifyArrivalOtp verifyArrivalOtp;
  late _MockRequestDeliveryOtp requestDeliveryOtp;
  late _MockVerifyDeliveryOtp verifyDeliveryOtp;

  const orderId = 'order-1';

  setUp(() {
    markArrived = _MockMarkArrived();
    verifyArrivalOtp = _MockVerifyArrivalOtp();
    requestDeliveryOtp = _MockRequestDeliveryOtp();
    verifyDeliveryOtp = _MockVerifyDeliveryOtp();
  });

  OtpVerifyCubit build() => OtpVerifyCubit(
    orderId: orderId,
    markArrived: markArrived,
    verifyArrivalOtp: verifyArrivalOtp,
    requestDeliveryOtp: requestDeliveryOtp,
    verifyDeliveryOtp: verifyDeliveryOtp,
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'a correct arrival code advances to unloading',
    setUp: () {
      when(
        () => verifyArrivalOtp(orderId: orderId, otp: '482913'),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.submitArrivalOtp('482913'),
    expect: () => const [
      OtpVerifyState.verifying(),
      OtpVerifyState.advanced(OrderStatus.unloading),
    ],
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'a wrong arrival code (422 -> ValidationFailure) is rejected, not thrown',
    setUp: () {
      when(
        () => verifyArrivalOtp(orderId: orderId, otp: '000000'),
      ).thenAnswer((_) async => const Left(Failure.validation('wrong otp')));
    },
    build: build,
    act: (cubit) => cubit.submitArrivalOtp('000000'),
    expect: () => const [OtpVerifyState.verifying(), OtpVerifyState.rejected()],
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'repeated wrong attempts (429 -> ThrottledFailure) surface the retry-after window',
    setUp: () {
      when(() => verifyArrivalOtp(orderId: orderId, otp: '111111')).thenAnswer(
        (_) async => const Left(Failure.throttled(retryAfter: Duration(minutes: 15))),
      );
    },
    build: build,
    act: (cubit) => cubit.submitArrivalOtp('111111'),
    expect: () => const [
      OtpVerifyState.verifying(),
      OtpVerifyState.throttled(retryAfter: Duration(minutes: 15)),
    ],
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'a correct delivery code advances to delivered',
    setUp: () {
      when(
        () => verifyDeliveryOtp(orderId: orderId, otp: '654321'),
      ).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.submitDeliveryOtp('654321'),
    expect: () => const [
      OtpVerifyState.verifying(),
      OtpVerifyState.advanced(OrderStatus.delivered),
    ],
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'markArrived() generates the arrival OTP without ever seeing its value',
    setUp: () {
      when(() => markArrived(orderId)).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.markArrived(),
    expect: () => const [OtpVerifyState.verifying(), OtpVerifyState.idle()],
    verify: (_) => verify(() => markArrived(orderId)).called(1),
  );

  blocTest<OtpVerifyCubit, OtpVerifyState>(
    'requestDeliveryOtp() generates the delivery OTP without ever seeing its value',
    setUp: () {
      when(() => requestDeliveryOtp(orderId)).thenAnswer((_) async => const Right(null));
    },
    build: build,
    act: (cubit) => cubit.requestDeliveryOtp(),
    expect: () => const [OtpVerifyState.verifying(), OtpVerifyState.idle()],
    verify: (_) => verify(() => requestDeliveryOtp(orderId)).called(1),
  );

  test(
    'no OtpVerifyState variant carries an OTP code (structural guarantee, SC-008): '
    'toString() of every variant is free of the submitted digits',
    () {
      const states = [
        OtpVerifyState.idle(),
        OtpVerifyState.verifying(),
        OtpVerifyState.advanced(OrderStatus.unloading),
        OtpVerifyState.rejected(),
        OtpVerifyState.throttled(retryAfter: Duration(minutes: 15)),
      ];
      for (final state in states) {
        expect(state.toString(), isNot(contains('482913')));
      }
    },
  );
}
