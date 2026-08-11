import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/localization/translation_keys.dart';
import '../../../../core/realtime/tracking_socket.dart';
import 'location_emit_gate.dart';

/// Streams the driver's position while an order is active, applying the
/// backend's displacement/heartbeat policy client-side before ever emitting
/// (research R4, gating logic in [LocationEmitGate]) — the server
/// re-enforces the same policy regardless. Runs in the foreground and,
/// only for the duration of an active delivery, escalates to background
/// via a foreground-service notification (Android) / background location
/// updates (iOS) — never always-on.
class LocationStreamService {
  LocationStreamService({required TrackingSocket socket})
    : _socket = socket,
      _gate = LocationEmitGate();

  final TrackingSocket _socket;
  final LocationEmitGate _gate;
  StreamSubscription<Position>? _subscription;

  bool get isStreaming => _subscription != null;

  /// Returns `false` if location permission was denied — callers should
  /// surface that as a blocking condition for starting a delivery.
  Future<bool> start() async {
    if (_subscription != null) return true;
    if (!await _ensurePermission()) return false;

    _subscription = Geolocator.getPositionStream(
      locationSettings: _platformSettings(),
    ).listen(_handlePosition);
    return true;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _gate.reset();
  }

  void _handlePosition(Position position) {
    final now = DateTime.now();
    final accepted = _gate.shouldEmit(
      lat: position.latitude,
      lng: position.longitude,
      now: now,
    );
    if (!accepted) return;

    unawaited(
      _socket.sendLocation(
        lat: position.latitude,
        lng: position.longitude,
        recordedAt: now,
      ),
    );
  }

  Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  LocationSettings _platformSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        // Our own displacement/heartbeat gate above decides what to emit;
        // this only bounds how often the OS delivers raw fixes to us.
        distanceFilter: 0,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: DriverKeys.deliveryInProgress.tr(),
          notificationText: DriverKeys.sharingLocation.tr(),
          enableWakeLock: true,
        ),
      );
    }
    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
      );
    }
    return const LocationSettings(accuracy: LocationAccuracy.high);
  }
}
