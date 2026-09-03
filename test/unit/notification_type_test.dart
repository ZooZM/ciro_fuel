import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/shared/enums/notification_type.dart';

/// spec 007 research R10 (`mobile_app/CLAUDE.md` debt #5): before this
/// feature, this enum and the backend's shared exactly one value
/// (`PAYMENT_TIMEOUT`) — every other member was a misspelled or invented
/// wire string, so every live notification silently degraded to [unknown].
/// This test is what keeps the two from drifting apart again: every real
/// backend wire value (`src/common/enums/notification-type.enum.ts`,
/// mirrored here since Dart has no way to read the TypeScript source
/// directly) must map to its own named member, never to [unknown].
void main() {
  // Kept in sync by hand with src/common/enums/notification-type.enum.ts —
  // there is no shared source of truth across the two languages, so a
  // change on either side must update both, and this list is the check
  // that they still agree.
  const backendWireValues = [
    'ORDER_APPROVED_FINAL_PRICE',
    'NO_DRIVER_AVAILABLE',
    'PAYMENT_TIMEOUT',
    'ORDER_ASSIGNED',
    'ORDER_STATUS_CHANGED',
    'OTP_ISSUED',
    'PAYMENT_RECONCILIATION_REQUIRED',
    'ORDER_ROUTED_TO_TRANSPORT',
    'SUPPORT_REQUEST_RAISED',
    // spec 011: the stop prompt. Also the one type the app raises a
    // device-level alert for (FR-004a) — but as far as this parity check is
    // concerned it is an ordinary wire value like any other.
    'DRIVER_STOP_DETECTED',
    // feature 013 US5a: a transport-admin notification, mirrored so
    // this parity check stays exhaustive.
    'ORDER_DRIVER_BLOCKED',
  ];

  test('every backend wire value maps to a named member, never unknown', () {
    for (final wire in backendWireValues) {
      final parsed = NotificationType.fromWire(wire);
      expect(
        parsed,
        isNot(NotificationType.unknown),
        reason: '$wire degraded to unknown — the enums have drifted apart',
      );
      // Round-trips: the member this wire value parses to reports the same
      // wire value back, so no two backend values can collide on one member.
      expect(parsed.toWire(), wire);
    }
  });

  test('an unrecognised value degrades to unknown rather than throwing', () {
    expect(
      NotificationType.fromWire('SOME_FUTURE_TYPE_NOT_YET_ADDED'),
      NotificationType.unknown,
    );
  });

  test('every named member (other than unknown) is one of the backend values', () {
    // The inverse check: guards against the app enum growing a member that
    // has no backend counterpart at all — the exact shape of the original
    // bug (deliveryCompleted, finalPriceReady, noEligibleDriver never
    // matched anything real).
    for (final member in NotificationType.values) {
      if (member == NotificationType.unknown) continue;
      expect(
        backendWireValues.contains(member.wire),
        isTrue,
        reason: '${member.name} (${member.wire}) has no backend counterpart',
      );
    }
  });
}
