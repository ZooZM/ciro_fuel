import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/enums/order_status.dart';

part 'otp_verify_state.freezed.dart';

/// No variant ever carries an OTP code — the driver build never holds or
/// renders one (FR-012/017, SC-008).
@freezed
sealed class OtpVerifyState with _$OtpVerifyState {
  const factory OtpVerifyState.idle() = OtpVerifyIdle;
  const factory OtpVerifyState.verifying() = OtpVerifying;
  const factory OtpVerifyState.advanced(OrderStatus to) = OtpVerifyAdvanced;
  const factory OtpVerifyState.rejected() = OtpVerifyRejected;
  const factory OtpVerifyState.throttled({Duration? retryAfter}) =
      OtpVerifyThrottled;
}
