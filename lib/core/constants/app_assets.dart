/// The single place asset paths are spelled out (Constitution Principle I).
///
/// Several folders shipped from design contain spaces (`assets/sign in/`,
/// `assets/social media/`) and one filename has a trailing space before its
/// extension. Those quirks are contained here rather than being repeated —
/// and mistyped — across the widget tree.
abstract final class AppAssets {
  static const String _signIn = 'assets/SignIn';
  static const String _logo = 'assets/logo';
  static const String _icons = 'assets/icons';
  static const String _biometric = 'assets/biometric';
  static const String _social = 'assets/social media';
  static const String _homePage = 'assets/HomePage';
  static const String _homeFlow = '$_homePage/flow';
  static const String _order = 'assets/Order';

  // Sign-in scene
  static const String loginBackground = '$_signIn/background .jpg';
  static const String loginWave = '$_signIn/Wave.svg';

  // Brand
  static const String logo = '$_logo/Logo.svg';

  // UI icons
  static const String phoneIcon = '$_icons/phone.svg';
  static const String lockIcon = '$_icons/locked.svg';
  static const String shieldIcon = '$_icons/protection.svg';
  static const String supportIcon = '$_icons/customer service.svg';

  // Biometrics
  static const String faceIdIcon = '$_biometric/Face ID.svg';
  static const String fingerprintIcon = '$_biometric/Android Fingerprint.svg';

  // Federated identity providers
  static const String appleIcon = '$_social/apple.svg';
  static const String googleIcon = '$_social/google.svg';

  /// Root passed to `EasyLocalization(path: ...)`.
  static const String translationsPath = 'assets/translations';

  // Client home dashboard
  static const String appBarLogo = '$_homePage/appBar Logo.svg';
  static const String dashboardProfileImage = '$_homePage/profile image.png';
  static const String notificationIcon = '$_icons/notification.svg';
  static const String dashboardStationIcon = '$_homePage/green station.svg';
  static const String dashboardAvailableBalanceIcon =
      '$_homePage/green gun.svg';
  static const String dashboardPendingInvoiceIcon =
      '$_homePage/red invoice.svg';

  // 'gas .svg' has the grade "95" baked into the artwork, so it can only
  // ever be correct for one tile; 'gas station.svg' is the same pump
  // without the number.
  static const String dashboardGasStationIcon = '$_homePage/gas station.svg';
  static const String dashboardTruckIcon = '$_homePage/truck.svg';

  // Despite its name, 'السائق.svg' is the tanker artwork and 'profile.svg'
  // is the person — so the driver row uses profile and the truck row uses
  // السائق.
  static const String dashboardDriverIcon = '$_homePage/profile.svg';
  static const String dashboardLorryIcon = '$_homePage/السائق.svg';
  static const String dashboardDateIcon = '$_homePage/date.svg';

  // Delivery-timeline bubbles. These two carry their own filled circle, so
  // they stand in for the whole bubble once their step is behind us.
  static const String orderFlowDropIcon = '$_homeFlow/drop.svg';
  static const String orderFlowTruckIcon = '$_homeFlow/truck.svg';

  static const String dashboardHourIcon = '$_homeFlow/hour.svg';

  /// Grey (#9CA3AF) artwork, so it is tinted to the counter's colour at use.
  static const String dashboardStatTruckIcon = '$_icons/truck.svg';

  static const String dashboardMapIcon = '$_homePage/map.svg';
  static const String dashboardAddIcon = '$_homePage/add.svg';

  // Order detail / tracking
  static const String copyIcon = '$_icons/copy.svg';
  static const String qrCodeImage = '$_icons/QR Code.png';
  static const String sadaadLogo = '$_order/Sadaad.svg';
  static const String successSealAnimation = '$_order/Done.gif';

  // Create-order form
  // 'station.svg' is a 1024x1024 PNG embedded as base64 and painted through
  // an SVG <pattern>. flutter_svg does not rasterise <image> elements, so
  // it draws nothing — this is that same bitmap, extracted so it can be
  // shown directly.
  static const String orderStationArt = '$_order/station.png';
  static const String orderPinIcon = '$_order/pin.svg';
  static const String orderBarePinIcon = '$_order/bare pin.svg';
  static const String orderScheduleIcon = '$_icons/schedule.svg';

  /// The forecourt that bleeds off the leading edge of the موعد التسليم
  /// card. Distinct from [dashboardStationIcon], which is the dashboard's
  /// green pump badge.
  static const String orderStationIcon = '$_order/station_icon.svg';
  static const String orderDateIcon = '$_order/date.svg';
  static const String orderFlashIcon = '$_order/flash.svg';

  // Track-order screen
  static const String orderDriverPhoto = '$_order/driver image.png';
  static const String orderTankTruckImage = '$_order/tank_truck.png';

  // The map is a flat image until a maps SDK is wired in; its zoom and
  // locate controls are part of the artwork.
  static const String orderMapImage = '$_order/map.png';
  static const String orderMapReloadIcon = '$_order/reload.svg';
  static const String orderMapZoomInIcon = '$_order/zoom_in.svg';
  static const String orderMapZoomOutIcon = '$_order/zoom_out.svg';
  static const String orderMapShareIcon = '$_order/share.svg';
}
