import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// spec 005 T124/FR-002: fails the build when any file whose name contains
/// "mock" is reachable — via `import`, transitively — from `lib/main.dart`,
/// the app's real entry point. A grep is sufficient (per the task), so this
/// walks the plain `import '...'` graph rather than resolving Dart's full
/// analysis model; that's enough to catch exactly the class of bug this
/// guards against (`order_mock_data.dart`, `mock_order_state.dart` and
/// `role_selection_mock_screen.dart` were all real instances of it, found
/// and removed in this same phase).
///
/// A `*mock*.dart` file under `test/` is unaffected — nothing there is ever
/// imported by `lib/main.dart`. A mock *constant* living inside a
/// legitimately-named file (there is at least one remaining, intentionally,
/// on the driver side) is also outside this check's reach — it greps file
/// names, not file contents, matching the task's own stated bar.
void main() {
  test('no *mock* file is reachable from lib/main.dart', () {
    final visited = <Uri>{};
    final queue = <Uri>[File('lib/main.dart').absolute.uri];
    final mockFilesReached = <String>{};
    final importPattern = RegExp(r'''import\s+['"]([^'"]+)['"]''');

    while (queue.isNotEmpty) {
      final fileUri = queue.removeLast();
      if (!visited.add(fileUri)) continue;

      final file = File.fromUri(fileUri);
      if (!file.existsSync()) continue;
      if (fileUri.pathSegments.last.toLowerCase().contains('mock')) {
        mockFilesReached.add(fileUri.toFilePath());
      }

      // The directory this file lives in, as a URI ending in '/' — the
      // base every relative import in it resolves against.
      final dirUri = fileUri.resolve('.');

      for (final match in importPattern.allMatches(file.readAsStringSync())) {
        final target = match.group(1)!;
        // Only relative (package-internal) imports resolve to a real file
        // this way — 'package:flutter/...' and 'dart:...' are skipped.
        if (target.startsWith('package:') || target.startsWith('dart:')) {
          continue;
        }
        // Uri.resolve collapses '..'/'.' segments per RFC 3986, so the same
        // real file always lands as the same key regardless of which
        // importer's relative depth reached it — without that, this queue
        // never converges.
        queue.add(dirUri.resolve(target));
      }
    }

    expect(
      mockFilesReached,
      isEmpty,
      reason:
          'These files are reachable from lib/main.dart and have "mock" in '
          'their own name — either wire the real thing in their place, or '
          'if they are genuinely still needed as a preview, keep them out '
          'of the reachable import graph (FR-002):\n'
          '${mockFilesReached.join('\n')}',
    );
  });
}
