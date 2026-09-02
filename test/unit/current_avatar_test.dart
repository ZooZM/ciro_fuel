import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/session/current_avatar.dart';

void main() {
  setUp(CurrentAvatar.clear);
  tearDown(() {
    CurrentAvatar.clear();
    CurrentAvatar.loader = null;
  });

  group('CurrentAvatar', () {
    test('starts empty, so the app bar shows a glyph rather than a stranger', () {
      expect(CurrentAvatar.bytes.value, isNull);
    });

    test('fetches at most once, however often the app bar rebuilds', () async {
      // The header is rebuilt constantly; a fetch per rebuild would hammer
      // the backend for a value that only changes on upload.
      var calls = 0;
      CurrentAvatar.loader = () async {
        calls++;
        CurrentAvatar.publish(Uint8List.fromList([1, 2, 3]));
      };

      await CurrentAvatar.ensureLoaded();
      await CurrentAvatar.ensureLoaded();
      CurrentAvatar.warmUp();
      await Future<void>.delayed(Duration.zero);

      expect(calls, 1);
      expect(CurrentAvatar.bytes.value, isNotNull);
    });

    test('an upload replaces what the header is showing', () {
      CurrentAvatar.publish(Uint8List.fromList([1]));
      CurrentAvatar.publish(Uint8List.fromList([2, 2]));
      expect(CurrentAvatar.bytes.value, hasLength(2));
    });

    test('sign-out drops it, so the next account never wears the last face', () async {
      CurrentAvatar.loader = () async =>
          CurrentAvatar.publish(Uint8List.fromList([1, 2, 3]));
      await CurrentAvatar.ensureLoaded();
      expect(CurrentAvatar.bytes.value, isNotNull);

      CurrentAvatar.clear();
      expect(CurrentAvatar.bytes.value, isNull);

      // And the one-shot latch resets, so the next user's picture is fetched
      // rather than skipped as "already attempted".
      var refetched = false;
      CurrentAvatar.loader = () async => refetched = true;
      await CurrentAvatar.ensureLoaded();
      expect(refetched, isTrue);
    });
  });
}
