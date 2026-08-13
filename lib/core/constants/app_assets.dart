/// The single place asset paths are spelled out (Constitution Principle I).
///
/// Several folders shipped from design contain spaces (`assets/help screen/`,
/// `assets/social media/`) and one filename has a trailing space before its
/// extension. Those quirks are contained here rather than being repeated —
/// and mistyped — across the widget tree.
///
/// Every path below must match `pubspec.yaml`'s declaration **exactly**,
/// including case. The declared string is what Flutter writes into
/// AssetManifest, and the lookup behind `SvgPicture.asset` / `AssetImage` is
/// an ordinary case-sensitive map read — but `flutter test` resolves assets
/// off the (case-insensitive on macOS) filesystem instead, so a mis-cased
/// path passes every test here and then renders nothing on a device. That is
/// exactly how `assets/Icons/…` and `assets/Logo/…` went unnoticed.
abstract final class AppAssets {
  static const String _signIn = 'assets/SignIn';
  static const String _logo = 'assets/logo';
  static const String _icons = 'assets/icons';
  static const String _biometric = 'assets/biometric';
  static const String _social = 'assets/social media';
  static const String _invoices = 'assets/invoices';
  static const String _homePage = 'assets/HomePage';
  static const String _homeFlow = '$_homePage/flow';
  static const String _order = 'assets/Order';
  static const String _more = 'assets/more';
  static const String _help = 'assets/help screen';

  // Sign-in scene
  static const String loginBackground = '$_signIn/background .jpg';
  static const String loginWave = '$_signIn/Wave.svg';

  // Brand
  //
  // Both wordmarks live in `assets/Logo/` — the stacked mark and the one the
  // top bar draws — and each ships in two cuts. CIRO is drawn in black, which
  // disappears on a dark canvas, so the dark cut is the same artwork with only
  // those letterforms redrawn in white; the green accent on the R (#12A150) and
  // the blue FUEL (#1E5FFF) read on dark already and are identical in both
  // files. A `colorFilter` cannot do this —
  // it would flatten every colour into one. Prefer the [AppLogo] and
  // [AppLogoMark] widgets over naming a constant directly; they pick the cut
  // for the active theme.
  static const String logo = '$_logo/Logo.svg';
  static const String logoDark = '$_logo/Logo Dark.svg';
  static const String appBarLogo = '$_logo/appBar Logo.svg';
  static const String appBarLogoDark = '$_logo/appBar Logo Dark.svg';

  // Action chips (reload / download / filter)
  //
  // Each of these is a whole button rather than a glyph: a tinted chip, a
  // hairline border and a coloured mark. A `colorFilter` would flatten all
  // three into one colour, so — as with the wordmark — each ships a dark cut
  // that remaps every role to its dark-palette counterpart. Reach for
  // [AppActionIcon] instead of naming a pair directly.
  static const String filterIcon = '$_icons/filter.svg';
  static const String filterIconDark = '$_icons/filter_dark.svg';
  static const String reloadIcon = '$_invoices/reload.svg';
  static const String reloadIconDark = '$_invoices/reload_dark.svg';
  static const String downloadIcon = '$_invoices/download.svg';
  static const String downloadIconDark = '$_invoices/download_dark.svg';

  /// The payments screen draws its reload from a second copy of the artwork.
  static const String paymentsReloadIcon = '$_icons/reload.svg';
  static const String paymentsReloadIconDark = '$_icons/reload_dark.svg';

  // UI icons
  static const String phoneIcon = '$_icons/phone.svg';
  static const String lockIcon = '$_icons/locked.svg';
  static const String shieldIcon = '$_icons/protection.svg';
  static const String supportIcon = '$_icons/customer service.svg';
  static const String requestCreditLimitIcon = '$_icons/request_credit_limit.svg';
  static const String payCardIcon = '$_icons/pay_card.svg';

  /// The list screens' refresh glyph. Distinct from [orderMapReloadIcon],
  /// which is the map control from the Order folder.

  /// The bell's unread dot, drawn as its own artwork on the screens that do
  /// not compose the badge from a [Container].
  static const String notificationBadgeIcon = '$_icons/notification_badge.svg';

  // Biometrics
  static const String faceIdIcon = '$_biometric/Face ID.svg';
  static const String fingerprintIcon = '$_biometric/Android Fingerprint.svg';

  // Federated identity providers
  static const String appleIcon = '$_social/apple.svg';
  static const String googleIcon = '$_social/google.svg';

  // Support channels — full-colour brand marks, so they are never tinted.
  static const String facebookIcon = '$_social/facebook.svg';
  static const String telegramIcon = '$_social/telegram.svg';
  static const String whatsappIcon = '$_social/whatsapp.svg';

  /// Root passed to `EasyLocalization(path: ...)`.
  static const String translationsPath = 'assets/translations';

  // Client home dashboard
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
  static const String orderCustomQuantityIcon = '$_icons/edit.svg';

  // Help & support
  //
  // The nozzle is drawn in two colours — a green body over orange drips — so
  // it must not be recoloured through a `colorFilter`.
  static const String supportGasGunIcon = '$_help/gas gun.svg';
  static const String supportSendIcon = '$_help/send.svg';

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

  // ---------------------------------------------------------------------
  // More / settings screen
  // ---------------------------------------------------------------------
  static const String moreProfileImage = '$_more/Image.png';
  static const String moreStationIcon = '$_more/station.svg';
  static const String moreInvoiceIcon = '$_more/invoice.svg';

  /// A 16x16 stroked credit card in Ignition Orange — retinted per use, so
  /// it serves both the settings row and the credit-limit screen's tiles.
  static const String morePaymentIcon = '$_more/payment.svg';
  static const String moreSupportIcon = '$_more/customer service.svg';

  /// The document glyph behind الشروط و الأحكام, in the settings list and
  /// again on the credit-limit form's terms row.
  static const String moreTermsIcon = '$_more/order.svg';
  static const String moreLanguageIcon = '$_more/language.svg';

  // The switch is drawn as artwork rather than composed from a Material
  // Switch. Despite the file name, "Pressed" is the *off* state.
  static const String moreToggleOnIcon = '$_more/Toggole Button.svg';
  static const String moreToggleOffIcon = '$_more/Toggole Button Pressed.svg';

  // ---------------------------------------------------------------------
  // Support screen — the four most-searched topics
  // ---------------------------------------------------------------------
  static const String supportFuelOrdersIcon = '$_help/gas.svg';
  static const String supportDeliveryDelayIcon = '$_help/truck.svg';
  static const String supportPaymentIcon = '$_help/contract.svg';
  static const String supportAccountIcon = '$_help/profile.svg';

  /// Calendar glyph on the stations screen's last-order card. Distinct from
  /// [dashboardDateIcon], which is the dashboard's own copy.
  static const String dateIcon = '$_icons/date.svg';
}
