import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/location/position_reader.dart';
import '../../../../core/network/error_codes.dart';
import '../../../../core/nfc/nfc_reader.dart';
import '../../../../shared/enums/verification_method.dart';
import '../../domain/usecases/verify_vehicle.dart';
import 'vehicle_verification_state.dart';

/// Drives departure/loading verification (spec 008 US3). One instance per
/// order (`registerFactoryParam`, keyed by orderId — same lifecycle as
/// `OtpVerifyCubit`).
///
/// Never decides whether a credential matches, and never holds one in
/// state — `readTagAndVerify`/`verifyCode` take it as a parameter and pass
/// it straight to the backend (FR-022/FR-042). Which stage is being
/// attempted is likewise never this cubit's decision: the backend derives
/// it server-side from the order's own status (research R7).
class VehicleVerificationCubit extends Cubit<VehicleVerificationState> {
  VehicleVerificationCubit({
    required String orderId,
    required NfcReader nfcReader,
    required VerifyVehicle verifyVehicle,
    required PositionReader positionReader,
  }) : _orderId = orderId,
       _nfcReader = nfcReader,
       _verifyVehicle = verifyVehicle,
       _positionReader = positionReader,
       super(const VehicleVerificationState.idle(nfcAvailable: false));

  final String _orderId;
  final NfcReader _nfcReader;
  final VerifyVehicle _verifyVehicle;
  final PositionReader _positionReader;

  /// Called once from the screen's `initState` (never from this
  /// constructor — attaching platform-channel checks at construction time
  /// is the pattern `mobile_app/CLAUDE.md` debt #6 already flags as a
  /// silent-no-op trap).
  Future<void> checkAvailability() async {
    final available = await _nfcReader.isAvailable();
    emit(VehicleVerificationState.idle(nfcAvailable: available));
  }

  /// Waits for a single tap and submits it. A cancelled/timed-out read (no
  /// tag ever presented) returns quietly to idle — that is not a refusal,
  /// there was nothing to refuse.
  Future<void> readTagAndVerify() async {
    emit(const VehicleVerificationState.reading());
    final tagId = await _nfcReader.readTagId();
    if (tagId == null) {
      emit(const VehicleVerificationState.idle(nfcAvailable: true));
      return;
    }
    // TEMPORARY (manual pairing test) — the platform never surfaces a raw
    // credential back to the app (FR-018/FR-042), so this is the only way to
    // read a physical card's UID for POST /trucks/:id/pair-card. Remove once
    // the test truck's card is paired.
    debugPrint('[NFC] tag id: $tagId');
    await _verify(tagId, VerificationMethod.nfcCard);
  }

  /// The QR path (FR-036a) — `code` comes from the app's own live camera
  /// preview only; this method has no opinion on where it came from, that
  /// discipline lives entirely in the screen that calls it.
  Future<void> verifyCode(String code) => _verify(code, VerificationMethod.qrCode);

  /// Every attempt carries a fresh fix when the device can give one — at
  /// LOADING because the platform refuses the stage without it (FR-030a/c),
  /// at DEPARTURE because it is simply a truer answer to what FR-024
  /// records than the driver's last streamed position.
  ///
  /// A missing fix is NOT pre-judged here: the request goes out without
  /// one, and the platform decides whether this particular stage needed it.
  /// Which stage is being attempted has never been this cubit's to know
  /// (research R7), and guessing it in order to refuse locally would be the
  /// same mistake in a new place.
  Future<void> _verify(String credential, VerificationMethod method) async {
    emit(const VehicleVerificationState.submitting());
    final fix = await _positionReader.currentFix();
    final result = await _verifyVehicle(
      orderId: _orderId,
      credential: credential,
      method: method,
      driverLocation: fix,
    );
    result.fold((failure) => emit(_toState(failure)), (order) {
      emit(VehicleVerificationState.verified(order));
    });
  }

  VehicleVerificationState _toState(Failure failure) => switch (failure) {
    ThrottledFailure(:final retryAfter) => VehicleVerificationState.throttled(
      retryAfter: retryAfter,
    ),
    NetworkFailure() || ServerFailure() => const VehicleVerificationState.failure(
      unreachable: true,
    ),
    ValidationFailure(:final code) when code == ErrorCodes.vehicleMismatch =>
      const VehicleVerificationState.mismatch(),
    ValidationFailure(:final code, :final extra)
        when code == ErrorCodes.notAtWarehouse =>
      VehicleVerificationState.notAtWarehouse(
        distanceMeters: switch (extra?['distanceMeters']) {
          final num d => d.toDouble(),
          _ => null,
        },
      ),
    ValidationFailure(:final code) when code == ErrorCodes.locationRequired =>
      const VehicleVerificationState.locationUnavailable(),
    _ => const VehicleVerificationState.failure(),
  };

  @override
  Future<void> close() {
    unawaited(_nfcReader.stopSession());
    return super.close();
  }
}
