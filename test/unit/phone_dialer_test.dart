import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/utils/phone_dialer.dart';

void main() {
  final launched = <Uri>[];

  setUp(() {
    launched.clear();
    PhoneDialer.launcher = (uri) async {
      launched.add(uri);
      return true;
    };
  });

  group('PhoneDialer.call', () {
    test('hands an E.164 number to the platform as a tel: URI', () async {
      expect(await PhoneDialer.call('+966500000003'), isTrue);
      expect(launched.single.scheme, 'tel');
      expect(launched.single.path, '+966500000003');
    });

    test('strips formatting the dialler cannot parse, keeping the + prefix', () async {
      expect(await PhoneDialer.call(' +966 (50) 000-0003 '), isTrue);
      expect(launched.single.path, '+966500000003');
    });

    test('does nothing when there is no number to dial', () async {
      for (final input in [null, '', '   ', '-- --']) {
        expect(await PhoneDialer.call(input), isFalse, reason: 'input: "$input"');
      }
      expect(launched, isEmpty);
    });

    test('reports failure instead of throwing on a device without telephony', () async {
      // The simulator and iPads throw rather than returning false; an
      // escaping error here would surface as an unhandled exception on a tap.
      PhoneDialer.launcher = (_) async => throw Exception('no telephony');
      expect(await PhoneDialer.call('+966500000003'), isFalse);
    });
  });
}
