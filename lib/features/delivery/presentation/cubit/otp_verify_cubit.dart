import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/order_status.dart';
import '../../domain/usecases/mark_arrived.dart';
import '../../domain/usecases/request_delivery_otp.dart';
import '../../domain/usecases/verify_arrival_otp.dart';
import '../../domain/usecases/verify_delivery_otp.dart';
import 'otp_verify_state.dart';

/// Drives the two-step proof-of-delivery: **Arrived** generates the
/// arrival OTP (issued to the CLIENT, never here) then the driver enters
/// it via [submitArrivalOtp]; **Request delivery code** repeats the
/// pattern via [submitDeliveryOtp]. The OTP string itself only ever
/// exists as a method parameter — this cubit's state never carries one.
class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit({
    required String orderId,
    required MarkArrived markArrived,
    required VerifyArrivalOtp verifyArrivalOtp,
    required RequestDeliveryOtp requestDeliveryOtp,
    required VerifyDeliveryOtp verifyDeliveryOtp,
  }) : _orderId = orderId,
       _markArrived = markArrived,
       _verifyArrivalOtp = verifyArrivalOtp,
       _requestDeliveryOtp = requestDeliveryOtp,
       _verifyDeliveryOtp = verifyDeliveryOtp,
       super(const OtpVerifyState.idle());

  final String _orderId;
  final MarkArrived _markArrived;
  final VerifyArrivalOtp _verifyArrivalOtp;
  final RequestDeliveryOtp _requestDeliveryOtp;
  final VerifyDeliveryOtp _verifyDeliveryOtp;

  Future<void> markArrived() async {
    emit(const OtpVerifyState.verifying());
    final result = await _markArrived(_orderId);
    result.fold(
      (failure) => emit(_toState(failure)),
      (_) => emit(const OtpVerifyState.idle()),
    );
  }

  Future<void> submitArrivalOtp(String otp) async {
    emit(const OtpVerifyState.verifying());
    final result = await _verifyArrivalOtp(orderId: _orderId, otp: otp);
    result.fold(
      (failure) => emit(_toState(failure)),
      (_) => emit(const OtpVerifyState.advanced(OrderStatus.unloading)),
    );
  }

  Future<void> requestDeliveryOtp() async {
    emit(const OtpVerifyState.verifying());
    final result = await _requestDeliveryOtp(_orderId);
    result.fold(
      (failure) => emit(_toState(failure)),
      (_) => emit(const OtpVerifyState.idle()),
    );
  }

  Future<void> submitDeliveryOtp(String otp) async {
    emit(const OtpVerifyState.verifying());
    final result = await _verifyDeliveryOtp(orderId: _orderId, otp: otp);
    result.fold(
      (failure) => emit(_toState(failure)),
      (_) => emit(const OtpVerifyState.advanced(OrderStatus.delivered)),
    );
  }

  OtpVerifyState _toState(Failure failure) => switch (failure) {
    ThrottledFailure(:final retryAfter) => OtpVerifyState.throttled(retryAfter: retryAfter),
    _ => const OtpVerifyState.rejected(),
  };
}
