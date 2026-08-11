import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/constants/app_assets.dart';

/// Asset lookups are matched byte-for-byte at runtime, but Windows and macOS
/// resolve paths case-insensitively — so a path spelled `assets/Icons/...`
/// against a bundle key of `assets/icons/...` works on the dev machine and
/// silently renders nothing on Android. Four icons shipped that way.
///
/// `rootBundle.load` goes through the same manifest the device uses, so
/// asking it for every declared path is what catches the slip.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Every public path on [AppAssets]. Kept here rather than reflected so a
  /// new constant has to be added deliberately.
  const paths = <String, String>{
    'loginBackground': AppAssets.loginBackground,
    'loginWave': AppAssets.loginWave,
    'logo': AppAssets.logo,
    'logoDark': AppAssets.logoDark,
    'filterIcon': AppAssets.filterIcon,
    'filterIconDark': AppAssets.filterIconDark,
    'reloadIcon': AppAssets.reloadIcon,
    'reloadIconDark': AppAssets.reloadIconDark,
    'downloadIcon': AppAssets.downloadIcon,
    'downloadIconDark': AppAssets.downloadIconDark,
    'paymentsReloadIcon': AppAssets.paymentsReloadIcon,
    'paymentsReloadIconDark': AppAssets.paymentsReloadIconDark,
    'phoneIcon': AppAssets.phoneIcon,
    'lockIcon': AppAssets.lockIcon,
    'shieldIcon': AppAssets.shieldIcon,
    'supportIcon': AppAssets.supportIcon,
    'faceIdIcon': AppAssets.faceIdIcon,
    'fingerprintIcon': AppAssets.fingerprintIcon,
    'appleIcon': AppAssets.appleIcon,
    'googleIcon': AppAssets.googleIcon,
    'appBarLogo': AppAssets.appBarLogo,
    'appBarLogoDark': AppAssets.appBarLogoDark,
    'dashboardProfileImage': AppAssets.dashboardProfileImage,
    'notificationIcon': AppAssets.notificationIcon,
    'dashboardStationIcon': AppAssets.dashboardStationIcon,
    'dashboardAvailableBalanceIcon': AppAssets.dashboardAvailableBalanceIcon,
    'dashboardPendingInvoiceIcon': AppAssets.dashboardPendingInvoiceIcon,
    'dashboardGasStationIcon': AppAssets.dashboardGasStationIcon,
    'dashboardTruckIcon': AppAssets.dashboardTruckIcon,
    'dashboardDriverIcon': AppAssets.dashboardDriverIcon,
    'dashboardLorryIcon': AppAssets.dashboardLorryIcon,
    'dashboardDateIcon': AppAssets.dashboardDateIcon,
    'dashboardHourIcon': AppAssets.dashboardHourIcon,
    'dashboardStatTruckIcon': AppAssets.dashboardStatTruckIcon,
    'dashboardMapIcon': AppAssets.dashboardMapIcon,
    'dashboardAddIcon': AppAssets.dashboardAddIcon,
    'copyIcon': AppAssets.copyIcon,
    'qrCodeImage': AppAssets.qrCodeImage,
    'sadaadLogo': AppAssets.sadaadLogo,
    'successSealAnimation': AppAssets.successSealAnimation,
    'orderStationArt': AppAssets.orderStationArt,
    'orderPinIcon': AppAssets.orderPinIcon,
    'orderBarePinIcon': AppAssets.orderBarePinIcon,
    'orderScheduleIcon': AppAssets.orderScheduleIcon,
    'orderDateIcon': AppAssets.orderDateIcon,
    'orderFlashIcon': AppAssets.orderFlashIcon,
    'orderDriverPhoto': AppAssets.orderDriverPhoto,
    'orderTankTruckImage': AppAssets.orderTankTruckImage,
    'orderMapImage': AppAssets.orderMapImage,
    'orderMapReloadIcon': AppAssets.orderMapReloadIcon,
    'orderMapZoomInIcon': AppAssets.orderMapZoomInIcon,
    'orderMapZoomOutIcon': AppAssets.orderMapZoomOutIcon,
    'orderMapShareIcon': AppAssets.orderMapShareIcon,
  };

  paths.forEach((name, path) {
    test('AppAssets.$name resolves', () async {
      await expectLater(
        rootBundle.load(path),
        completes,
        reason: 'AppAssets.$name -> "$path" is not in the bundle',
      );
    });
  });

  test('every declared path is spelled with the bundle\'s exact case', () async {
    // The manifest, not the filesystem: `rootBundle.load` still goes through
    // the host's case-insensitive lookup under `flutter test`, so loading a
    // path successfully here proves nothing about the device.
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final keys = manifest.listAssets().toSet();
    final byLowerCase = {for (final k in keys) k.toLowerCase(): k};

    final wrong = <String, String>{};
    for (final entry in paths.entries) {
      if (keys.contains(entry.value)) continue;
      wrong[entry.key] = byLowerCase[entry.value.toLowerCase()] ?? '(absent)';
    }
    expect(wrong, isEmpty, reason: 'case mismatches: $wrong');
  });
}
