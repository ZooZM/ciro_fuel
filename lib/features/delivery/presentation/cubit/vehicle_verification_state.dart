import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/entities/order.dart';

part 'vehicle_verification_state.freezed.dart';

/// spec 008 US3 (FR-022/FR-042): this state never carries a credential —
/// the tag/code read only ever exists as a method parameter passed straight
/// through to the backend, which alone decides whether it matches
/// (`VehicleVerificationCubit` never compares anything itself).
@freezed
sealed class VehicleVerificationState with _$VehicleVerificationState {
  /// `nfcAvailable == false` is a normal, expected state on iOS without the
  /// paid-account entitlement, or on any device with no NFC hardware —
  /// never surfaced as an error (research R5).
  const factory VehicleVerificationState.idle({required bool nfcAvailable}) =
      VehicleVerificationIdle;

  const factory VehicleVerificationState.reading() = VehicleVerificationReading;

  const factory VehicleVerificationState.submitting() =
      VehicleVerificationSubmitting;

  /// The order as the backend just left it — the caller reloads the active
  /// delivery from this, never assumes what changed.
  const factory VehicleVerificationState.verified(Order order) =
      VehicleVerificationVerified;

  const factory VehicleVerificationState.mismatch() = VehicleVerificationMismatch;

  /// The right truck, read too far from the depot (FR-030a). Carries the
  /// distance the platform measured so the driver is told how far short
  /// they are, not merely that something was wrong — a driver at the wrong
  /// gate of the right yard and a driver still on the highway need
  /// different things from this screen, and only the number separates them.
  const factory VehicleVerificationState.notAtWarehouse({double? distanceMeters}) =
      VehicleVerificationNotAtWarehouse;

  /// The device could not produce a position at all, so the loading
  /// verification could not be judged (FR-030c). Distinct from every
  /// refusal above: nothing was recorded against the delivery, and the fix
  /// is on the phone (location off, permission refused), not at the depot.
  const factory VehicleVerificationState.locationUnavailable() =
      VehicleVerificationLocationUnavailable;

  const factory VehicleVerificationState.throttled({Duration? retryAfter}) =
      VehicleVerificationThrottled;

  /// `unreachable`: the request never reached the platform at all (FR-021) —
  /// nothing was recorded, and the driver must be told that plainly rather
  /// than left thinking the attempt counted. `false`: a recognised
  /// rejection that isn't a mismatch (e.g. the stage is no longer
  /// outstanding, FR-025) — distinct from `mismatch` so the three refusal
  /// causes FR-037 requires never collapse into one message (T094).
  const factory VehicleVerificationState.failure({
    @Default(false) bool unreachable,
  }) = VehicleVerificationFailure;
}
