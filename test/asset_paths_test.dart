import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards every asset path the app spells out against the two ways one can be
/// wrong on a Mac and right nowhere else.
///
/// `File('assets/Icons/date.svg').existsSync()` is **true** on macOS even
/// though the folder is called `icons`, and `flutter test`'s asset bundle
/// resolves off that same case-insensitive filesystem — so a mis-cased path
/// passes an ordinary render test and then renders nothing on a device, where
/// the lookup is a case-sensitive read of AssetManifest. This test therefore
/// compares strings against a real directory listing rather than asking the
/// filesystem whether a path exists.
///
/// It also checks the other half of the contract: that a `pubspec.yaml` entry
/// covers the path (an unbundled asset is missing everywhere, Mac included),
/// and that each declared folder matches its real name, since a
/// case-sensitive CI box cannot find `assets/Help Screen/` on disk.
void main() {
  late Set<String> filesOnDisk;
  late List<String> declaredEntries;

  setUpAll(() {
    filesOnDisk = _listAssetsWithRealCase();
    declaredEntries = _declaredAssetEntries();
  });

  test('every pubspec asset entry names something that exists, exactly', () {
    final wrong = <String>[];
    for (final entry in declaredEntries) {
      final isDirectory = entry.endsWith('/');
      final exists = isDirectory
          ? filesOnDisk.any((path) => path.startsWith(entry))
          : filesOnDisk.contains(entry);
      if (!exists) wrong.add(entry);
    }
    expect(
      wrong,
      isEmpty,
      reason:
          'These pubspec.yaml entries do not match any real path (usually a '
          'case difference — the declared string is what lands in '
          'AssetManifest, and a case-sensitive filesystem cannot find it).',
    );
  });

  test('every asset path in lib/ exists on disk with matching case', () {
    final wrong = <String, String>{};
    _assetPathsUsedInLib().forEach((path, usedBy) {
      if (filesOnDisk.contains(path)) return;
      final onDisk = filesOnDisk.firstWhere(
        (candidate) => candidate.toLowerCase() == path.toLowerCase(),
        orElse: () => 'no such file',
      );
      wrong[path] = 'used by $usedBy — on disk it is "$onDisk"';
    });
    expect(wrong, isEmpty, reason: wrong.entries.join('\n'));
  });

  test('every asset path in lib/ is covered by a pubspec entry', () {
    final directories = declaredEntries.where((e) => e.endsWith('/'));
    final files = declaredEntries.where((e) => !e.endsWith('/'));

    final uncovered = <String, String>{};
    _assetPathsUsedInLib().forEach((path, usedBy) {
      // Directory entries are not recursive: only a file sitting *directly*
      // inside a declared folder is bundled by it.
      final parent = '${path.substring(0, path.lastIndexOf('/'))}/';
      if (directories.contains(parent) || files.contains(path)) return;
      uncovered[path] = 'used by $usedBy';
    });
    expect(
      uncovered,
      isEmpty,
      reason:
          'Not bundled — add the containing folder to pubspec.yaml:\n'
          '${uncovered.entries.join('\n')}',
    );
  });
}

/// Every file under `assets/`, spelled the way the filesystem spells it.
///
/// Built from directory listings rather than `File.existsSync`, which is what
/// makes the comparison case-sensitive on a case-insensitive volume.
Set<String> _listAssetsWithRealCase() {
  return Directory('assets')
      .listSync(recursive: true)
      .whereType<File>()
      .map((file) => file.path)
      .where((path) => !path.endsWith('.DS_Store'))
      .toSet();
}

/// The `assets:` list from pubspec.yaml, read as text so the test needs no
/// YAML dependency. Stops at the next top-level key.
List<String> _declaredAssetEntries() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  final entries = <String>[];
  var inAssets = false;
  for (final line in lines) {
    if (line.trimRight() == '  assets:') {
      inAssets = true;
      continue;
    }
    if (!inAssets) continue;
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    if (!trimmed.startsWith('- ')) break;
    entries.add(trimmed.substring(2).trim());
  }
  expect(entries, isNotEmpty, reason: 'could not read the assets: list');
  return entries;
}

/// Every `'assets/…'` path named anywhere in `lib/`, mapped to what names it.
///
/// [AppAssets] builds its paths from private prefixes (`'$_icons/date.svg'`),
/// so those are resolved before the path is checked — the interpolation is
/// exactly where a mis-cased folder hides.
Map<String, String> _assetPathsUsedInLib() {
  final literal = RegExp(r"'(assets/[^']+\.[A-Za-z0-9]+)'");
  final used = <String, String>{};

  const appAssetsPath = 'lib/core/constants/app_assets.dart';
  final constants = <String, String>{};
  final declaration = RegExp(r"static const String (\w+) =\s*'([^']*)'");
  for (final match in declaration.allMatches(
    File(appAssetsPath).readAsStringSync(),
  )) {
    final resolved = match
        .group(2)!
        .replaceAllMapped(
          RegExp(r'\$(\w+)'),
          (reference) => constants[reference.group(1)] ?? '',
        );
    constants[match.group(1)!] = resolved;
    if (resolved.startsWith('assets/') && resolved.contains('.')) {
      used[resolved] = 'AppAssets.${match.group(1)}';
    }
  }

  for (final file
      in Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (f) => f.path.endsWith('.dart') && !f.path.endsWith(appAssetsPath),
          )) {
    for (final match in literal.allMatches(file.readAsStringSync())) {
      used[match.group(1)!] = file.path;
    }
  }
  return used;
}
