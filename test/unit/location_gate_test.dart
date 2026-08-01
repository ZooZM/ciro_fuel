import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/config/constants.dart';
import 'package:mobile_app/features/delivery/data/services/location_emit_gate.dart';

void main() {
  late LocationEmitGate gate;
  final t0 = DateTime.utc(2026, 1, 1, 12);

  setUp(() => gate = LocationEmitGate());

  test('the first fix is always emitted', () {
    expect(gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0), isTrue);
  });

  test('a fix within the emit floor is dropped even with large displacement', () {
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0);

    final withinFloor = t0.add(AppDurations.locationEmitFloor - const Duration(seconds: 1));
    final accepted = gate.shouldEmit(lat: 25.0, lng: 47.0, now: withinFloor);

    expect(accepted, isFalse);
  });

  test('past the floor, a fix under 50 m and under the heartbeat is dropped', () {
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0);

    // ~10 m north, well past the emit floor but nowhere near displacement/heartbeat.
    final later = t0.add(AppDurations.locationEmitFloor + const Duration(seconds: 1));
    final accepted = gate.shouldEmit(lat: 24.71369, lng: 46.6753, now: later);

    expect(accepted, isFalse);
  });

  test('a fix past 50 m displacement is emitted', () {
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0);

    // ~111 m north (0.001 deg lat ~ 111 m).
    final later = t0.add(AppDurations.locationEmitFloor + const Duration(seconds: 1));
    final accepted = gate.shouldEmit(lat: 24.7146, lng: 46.6753, now: later);

    expect(accepted, isTrue);
  });

  test('a fix at the heartbeat interval is emitted even with no displacement', () {
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0);

    final atHeartbeat = t0.add(AppDurations.locationHeartbeat);
    final accepted = gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: atHeartbeat);

    expect(accepted, isTrue);
  });

  test('an accepted emit resets the baseline for the next decision', () {
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: t0);
    final firstAccept = t0.add(AppDurations.locationHeartbeat);
    gate.shouldEmit(lat: 24.7136, lng: 46.6753, now: firstAccept);

    // Immediately after that accepted emit, small movement should be
    // dropped again (both floor and displacement reset).
    final justAfter = firstAccept.add(const Duration(seconds: 1));
    final accepted = gate.shouldEmit(lat: 24.71361, lng: 46.6753, now: justAfter);

    expect(accepted, isFalse);
  });
}
