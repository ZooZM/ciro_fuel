import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_presenter.dart';

/// The only place `flutter_local_notifications` is imported (spec 011 R4).
class LocalNotificationPresenter implements NotificationPresenter {
  LocalNotificationPresenter({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _taps = StreamController<String>.broadcast();
  bool _initialized = false;

  /// **The channel is not optional.** Since Android 8 a notification posted
  /// to a channel that was never created is *silently dropped* — no error,
  /// no log, nothing on screen. It is the exact failure that passes review
  /// and fails in the field, so the channel is created before anything is
  /// ever posted, with high importance so the alert actually surfaces over
  /// whatever the driver is looking at.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ciro_delivery_alerts',
    'Delivery alerts',
    description: 'Urgent alerts about the delivery you are currently carrying.',
    importance: Importance.high,
  );

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Authorization is requested explicitly in [ensurePermission] rather
        // than here, so the driver is asked at a moment that makes sense to
        // them rather than at a cold app start.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _taps.add(payload);
      },
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }

    _initialized = true;
  }

  @override
  Future<bool> ensurePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ requires this at runtime; the manifest declaration alone
      // is not enough. Older versions return null, which is a grant.
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return granted ?? true;
    }
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return false;
  }

  @override
  Future<void> present({
    required String title,
    required String body,
    required String payload,
  }) async {
    await initialize();
    await _plugin.show(
      // One notification id per alert kind: a second stop alert replaces the
      // first rather than stacking, since only one stop is ever unresolved
      // on a delivery at a time (spec 011 FR-016).
      _stopAlertNotificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          // The driver is driving — this must be audible, not a silent
          // badge they discover at the next stop.
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      payload: payload,
    );
  }

  @override
  Stream<String> get taps => _taps.stream;

  static const int _stopAlertNotificationId = 1101;
}
