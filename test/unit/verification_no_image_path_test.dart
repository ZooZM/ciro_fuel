import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// spec 008 FR-036i/FR-036j/SC-028: the QR credential is presentable only
/// through the app's own live camera preview — never a stored image. This
/// is deliberately a real discipline to test for: `image_picker` is already
/// a dependency (profile pictures, spec 005 T103), so nothing stops a
/// future edit from wiring a gallery-pick shortcut into the verification
/// flow by accident. A static source scan is what makes that impossible to
/// do silently, rather than trusting review to catch it every time.
void main() {
  test('no file under the verification flow imports image_picker', () {
    final root = Directory('lib/features/delivery');
    expect(root.existsSync(), isTrue, reason: 'delivery feature directory not found');

    // An actual import statement only — this file's own doc comments
    // legitimately name `image_picker` when explaining the absence.
    final importPattern = RegExp('''import\\s+['"]package:image_picker''');

    final offenders = <String>[];
    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final content = entity.readAsStringSync();
      if (importPattern.hasMatch(content)) {
        offenders.add(entity.path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These files under lib/features/delivery reference image_picker, '
          'which would let the vehicle-verification QR path accept a stored '
          'image instead of a live camera scan: $offenders',
    );
  });
}
