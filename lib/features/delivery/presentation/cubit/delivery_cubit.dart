import 'dart:async';

import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../shared/enums/order_status.dart';
import '../../data/services/location_stream_service.dart';
import '../../domain/usecases/acknowledge_assignment.dart';
import '../../domain/usecases/get_active_order.dart';
import '../../domain/usecases/verify_arrival_otp.dart';
import '../../domain/usecases/verify_delivery_otp.dart';
import 'delivery_state.dart';

/// Owns the driver's active-order lookup and the location stream's
/// lifecycle together: streaming starts only once a trackable job is
/// found and stops the moment the backend reports the order terminal
/// (research R4) — never left running idle.
///
/// Does not talk to `TrackingSocket` itself (spec 007 research R2): a
/// `registerLazySingleton` constructor runs at whatever unpredictable
/// moment something first resolves it, which could be before the socket
/// even connects — registering a handler there is a silent no-op, exactly
/// `mobile_app/CLAUDE.md` debt #6's failure mode for `NotificationsCubit`.
/// `DeliveryListener` owns the socket subscription instead, attached only
/// after `connect()` resolves, and drives this cubit through
/// [handleOrderStatus].
class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit({
    required GetActiveOrder getActiveOrder,
    required VerifyArrivalOtp verifyArrivalOtp,
    required VerifyDeliveryOtp verifyDeliveryOtp,
    required LocationStreamService locationStream,
    required AcknowledgeAssignment acknowledgeAssignment,
  }) : _getActiveOrder = getActiveOrder,
       _verifyArrivalOtp = verifyArrivalOtp,
       _verifyDeliveryOtp = verifyDeliveryOtp,
       _locationStream = locationStream,
       _acknowledgeAssignment = acknowledgeAssignment,
       // spec 007 FR-004/FR-032/FR-044: distinct from `noActiveOrder` — the
       // first is "still finding out", the second is "confirmed, nothing
       // assigned". Collapsing them (this cubit's state used to start
       // straight on `noActiveOrder`) is exactly what those requirements
       // forbid. `load()` itself does not re-emit `loading()` on every
       // call — only this initial state needs it, since a background
       // refresh (a status push, a new-assignment notification) already
       // has something worth keeping on screen until the new result lands.
       super(const DeliveryState.loading());

  final GetActiveOrder _getActiveOrder;
  final VerifyArrivalOtp _verifyArrivalOtp;
  final VerifyDeliveryOtp _verifyDeliveryOtp;
  final LocationStreamService _locationStream;
  final AcknowledgeAssignment _acknowledgeAssignment;

  Future<void> load() async {
    final result = await _getActiveOrder();
    // A reload can be in flight while the driver navigates away — notably the
    // one `confirmHandover` fires and does not await. Emitting into a closed
    // cubit throws, so every emit below is gated on still being open.
    if (isClosed) return;
    await result.fold((failure) async => emit(DeliveryState.failure(failure)), (
      order,
    ) async {
      if (order == null) {
        await _locationStream.stop();
        if (isClosed) return;
        emit(const DeliveryState.noActiveOrder());
        return;
      }
      final streaming = await _locationStream.start();
      if (isClosed) return;
      emit(DeliveryState.active(order, streaming: streaming));
      // spec 010 FR-010/FR-017: this is the explicit "the driver's device
      // genuinely displayed the assignment" moment the backend's
      // acknowledgment signal is defined by — never inferred from presence
      // alone. Fire-and-forget: the backend call is idempotent (a second
      // fire for an order reloaded via a status push is a harmless no-op),
      // and a failure here must never surface as a `DeliveryState.failure`
      // for the whole screen — the driver still sees their active
      // delivery either way; a persistently-failing acknowledgment simply
      // means the platform-side escalation proceeds, which is the correct
      // fallback this whole feature exists to provide.
      if (order.assignmentAcknowledgedAt == null) {
        unawaited(_acknowledgeAssignment(order.id));
      }
    });
  }

  /// Confirms the handover with the code the client is showing — typed in or
  /// read off their QR, which carry the same six digits.
  ///
  /// Which OTP this verifies follows the order's own status rather than
  /// anything the screen decides: `IN_TRANSIT` means the driver is proving
  /// they reached the station, `UNLOADING` that the fuel was handed over.
  /// The backend is the sole authority on both transitions, so a wrong code
  /// simply fails here and the order does not move.
  ///
  /// Returns null on success, or the failure to show. On success the active
  /// order is reloaded so the driver's screen reflects the new status.
  Future<Failure?> confirmHandover(String code) async {
    final current = state;
    if (current is! DeliveryActive) {
      return const Failure.validation('No active order to confirm');
    }

    final orderId = current.order.id;
    final result = switch (current.order.status) {
      OrderStatus.inTransit => await _verifyArrivalOtp(orderId: orderId, otp: code),
      OrderStatus.unloading => await _verifyDeliveryOtp(orderId: orderId, otp: code),
      // Nothing to confirm before the truck is moving or after it is done —
      // the button is hidden in those states, so this is belt and braces.
      _ => left<Failure, void>(
        const Failure.validation('This order is not awaiting a code'),
      ),
    };

    return result.fold((failure) => failure, (_) {
      unawaited(load());
      return null;
    });
  }

  /// Called by `DeliveryListener` on every `order:status` push (spec 007
  /// FR-026). Reloads from the platform rather than applying the payload's
  /// `to` locally — FR-015 makes the platform's response the only thing
  /// that may change a displayed stage, so this never sets state itself.
  /// `load()` alone decides whether to stop the location stream: its
  /// "no active order" branch stops it, and if the driver already has a
  /// next job lined up, `LocationStreamService.start()` is a no-op on an
  /// already-running stream — no special terminal-only case needed here.
  void handleOrderStatus(Map<String, dynamic> payload) {
    final current = state;
    if (current is! DeliveryActive) return;
    if (payload['orderId'] != current.order.id) return;
    unawaited(load());
  }

  /// Called on sign-out and on every session-ending revocation (spec 006
  /// FR-008/SC-002): stops the location stream and resets to a clean
  /// slate, so the next driver's first frame never shows the previous
  /// driver's active order. This cubit is a session-lifetime singleton
  /// (it owns the location stream's lifecycle across screens), so nothing
  /// else clears it between drivers.
  void clear() {
    unawaited(_locationStream.stop());
    emit(const DeliveryState.noActiveOrder());
  }

  @override
  Future<void> close() {
    unawaited(_locationStream.stop());
    return super.close();
  }
}
