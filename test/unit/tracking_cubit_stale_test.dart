import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/config/constants.dart';
import 'package:mobile_app/core/realtime/tracking_socket.dart';
import 'package:mobile_app/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:mobile_app/features/tracking/presentation/cubit/tracking_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockTrackingSocket extends Mock implements TrackingSocket {}

void main() {
  late _MockTrackingSocket socket;
  void Function(Map<String, dynamic>)? locationHandler;

  setUp(() {
    socket = _MockTrackingSocket();
    locationHandler = null;
    when(() => socket.onLocation(any())).thenAnswer((i) {
      locationHandler =
          i.positionalArguments[0] as void Function(Map<String, dynamic>);
    });
    when(() => socket.onConnect(any())).thenAnswer((_) {});
    when(() => socket.watchOrder(any())).thenAnswer((_) async => {'ok': true});
    when(() => socket.unwatchOrder(any())).thenAnswer((_) {});
  });

  test(
    'staleness is reported after locationStaleWindow with no update, '
    'evaluated against the wall clock',
    () {
      fakeAsync((async) {
        final cubit = TrackingCubit(socket: socket);
        addTearDown(cubit.close);

        unawaited(cubit.watch('order-1'));
        async.flushMicrotasks();
        expect(cubit.state, const TrackingState.watching());

        locationHandler!({
          'orderId': 'order-1',
          'lat': 24.7,
          'lng': 46.6,
          'recordedAt': DateTime.now().toUtc().toIso8601String(),
        });
        var watching = cubit.state as TrackingWatching;
        expect(watching.location, isNotNull);
        expect(watching.stale, isFalse);

        // Just under the window: the periodic check (every 15s) has run
        // several times by now, but staleness must not flip early.
        async.elapse(AppDurations.locationStaleWindow - const Duration(seconds: 30));
        watching = cubit.state as TrackingWatching;
        expect(watching.stale, isFalse);

        // Past the window by a full check interval, so the next periodic
        // check is guaranteed to have run since the window elapsed.
        async.elapse(AppDurations.staleCheckInterval + const Duration(seconds: 30));
        watching = cubit.state as TrackingWatching;
        expect(watching.stale, isTrue);
      });
    },
  );

  test(
    'a fresh update after going stale clears it',
    () {
      fakeAsync((async) {
        final cubit = TrackingCubit(socket: socket);
        addTearDown(cubit.close);

        unawaited(cubit.watch('order-1'));
        async.flushMicrotasks();
        locationHandler!({
          'orderId': 'order-1',
          'lat': 24.7,
          'lng': 46.6,
          'recordedAt': DateTime.now().toUtc().toIso8601String(),
        });

        async.elapse(
          AppDurations.locationStaleWindow + AppDurations.staleCheckInterval,
        );
        expect((cubit.state as TrackingWatching).stale, isTrue);

        locationHandler!({
          'orderId': 'order-1',
          'lat': 24.71,
          'lng': 46.61,
          'recordedAt': DateTime.now().toUtc().toIso8601String(),
        });
        expect((cubit.state as TrackingWatching).stale, isFalse);
      });
    },
  );
}
