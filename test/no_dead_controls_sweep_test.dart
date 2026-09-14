import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// feature 013 T077 (US5b): fails the build if an inert `onPressed: () {}` or
/// `onTap: () {}` handler survives on a driver-facing screen. A grep is the
/// stated bar — a no-op callback literal is unambiguous in source, and every
/// one of them on these screens was a control that did nothing when pressed.
void main() {
  final roots = [
    Directory('lib/features/delivery/presentation'),
    Directory('lib/features/support/presentation'),
  ];
  final profileDriverFiles = Directory('lib/features/profile/presentation/view')
      .listSync()
      .whereType<File>()
      .where((f) => f.uri.pathSegments.last.startsWith('driver_'));

  final deadHandler = RegExp(r'on(Pressed|Tap)\s*:\s*\(\s*\)\s*\{\s*\}');

  test('no inert onPressed/onTap handler remains on a driver screen', () {
    final offenders = <String>[];

    for (final file in [
      ...roots
          .where((d) => d.existsSync())
          .expand((d) => d.listSync(recursive: true))
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart')),
      ...profileDriverFiles,
    ]) {
      // Strip comments first — doc comments on these very files describe the
      // `onPressed: () {}` stubs they replaced, and those references are not
      // live code.
      //
      // CRLF normalisation is load-bearing, not tidiness. This checkout is
      // `core.autocrlf=true` with no `.gitattributes`, so a line arrives here
      // as `...active\r`. `RegExp(r'//.*$')` then fails outright: `.` does not
      // match the `\r` (it is a line terminator) and `$` without `multiLine`
      // only matches true end-of-input, so the comment survived the strip and
      // the sweep below matched five doc comments describing the very fix they
      // document — reporting the repo's own changelog as dead code.
      final src = file
          .readAsStringSync()
          .replaceAll('\r\n', '\n')
          .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
          .split('\n')
          .map((l) => l.replaceAll(RegExp(r'//.*'), ''))
          .join('\n');
      for (final match in deadHandler.allMatches(src)) {
        final line = '\n'.allMatches(src.substring(0, match.start)).length + 1;
        offenders.add('${file.path}:$line — ${match.group(0)}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Inert handlers found:\n${offenders.join('\n')}\nWire each to a real '
          'effect or remove the control.',
    );
  });
}
