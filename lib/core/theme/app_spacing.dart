/// Layout constants (Constitution Principle I — no magic values). Every
/// gap, radius and control size in the UI comes from here, so a design
/// system change is a one-file edit rather than a grep across widgets.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 36;

  /// Inset between the screen edge and on-screen content — the language
  /// pill and the login card share it, so their left edges line up as they
  /// do in the frame. Only the hero photograph ignores it and bleeds to the
  /// edges.
  static const double screenGutter = 24;

  /// Horizontal inset shared by the mockup-style screens (home dashboard,
  /// order detail) — a different frame from the one [screenGutter] was
  /// measured against.
  static const double gutter = 20;

  /// Bottom padding on the home dashboard's scroll view so content clears
  /// the floating bottom nav bar instead of running under it.
  static const double dashboardNavBarClearance = 120;

  /// Bottom padding on the order-detail scroll view so content clears the
  /// floating support FAB instead of running under it.
  static const double orderScreenBottomPadding = 100;

  /// Inset the list screens — my orders, invoices, payments — wrap
  /// [AppTopBar] in. Named so the three headers measure the same instead of
  /// each screen picking its own vertical padding, which is how they drifted
  /// apart in the first place.
  static const double topBarInsetH = 16;
  static const double topBarInsetV = 8;
}

/// Corner radii, named by the component they belong to rather than by size,
/// so intent survives a redesign.
abstract final class AppRadii {
  static const double field = 14;
  static const double sheet = 20;
  static const double chip = 20;
  static const double pill = 28;

  /// Small components across the mockup-style screens — buttons, tiles,
  /// stat/finance cards, the notification bell, receipt breakdown boxes.
  static const double tile = 12;

  /// Client home dashboard's larger cards — the current-station and
  /// current-order containers, and the order status badge.
  static const double dashboardCard = 16;
}

/// Fixed control heights and icon sizes taken from the Figma frame.
abstract final class AppSizes {
  static const double primaryButtonHeight = 54;

  // The frame draws these at 36/43dp. Both are raised to 44 — the smallest
  // reliable touch target — which is within a couple of pixels of the
  // design and keeps the card short enough for the hero photo to show.
  static const double secondaryButtonHeight = 44;
  static const double biometricButtonDiameter = 44;
  static const double checkboxSide = 18;
  static const double checkboxRadius = 4;
  static const double checkboxBorderWidth = 1.4;
  static const double dividerThickness = 1;
  static const double countryDividerHeight = 22;

  static const double iconXs = 13;
  static const double iconSm = 14;

  /// Reused across many otherwise-unrelated widgets (info rows, stat cards,
  /// action-button icons) — common enough in the design to warrant its own
  /// slot rather than a per-widget name.
  static const double icon16 = 16;
  static const double iconMd = 18;
  static const double iconLg = 20;
  static const double iconXl = 28;

  static const double logoWidth = 205;
  static const double waveWidth = 160;
  static const double progressStrokeWidth = 2.4;
  static const double progressDiameter = 22;

  /// Height of the hero photo band as a fraction of the screen.
  ///
  /// The photo is *not* stretched over the whole screen. Its source is a
  /// 720x1280 frame in which the tanker sits around the midpoint, with a
  /// long run of empty asphalt beneath it; filling the viewport therefore
  /// drops the tanker behind the card and leaves that asphalt as the only
  /// thing on show. Confining the photo to a band and cropping to
  /// [heroFocalY] lands the tanker just above the card instead.
  ///
  /// The band is set slightly *taller* than the card's top edge so the card
  /// covers where it ends — its own bottom edge is never visible.
  static const double heroBandFraction = 0.52;

  /// Vertical crop focus inside that band, in [Alignment] units. Biased
  /// well above centre: it discards the empty asphalt below the tanker,
  /// which is what pushes the tanker itself down to the foot of the band.
  static const double heroFocalY = -0.47;

  /// Where the scrim finishes fading the photo in from the canvas colour
  /// (top) and back out into it (bottom), as band-relative stops.
  static const double heroScrimTopStop = 0.35;
  static const double heroScrimBottomStop = 0.82;

  // ---------------------------------------------------------------------
  // Client home dashboard
  // ---------------------------------------------------------------------
  /// The avatar in the top bar. Larger than the 44 the bell tile beside it
  /// runs at — a circle reads smaller than a rounded square of the same size,
  /// so matching them left the avatar looking undersized.
  static const double dashboardProfileImageSize = 58;

  /// The top bar is as tall as its tallest element — the avatar — so nothing
  /// bleeds past its box.
  static const double topBarHeight = dashboardProfileImageSize;
  static const double appBarLogoHeight = 20;
  static const double dashboardNotificationIconSize = 20;
  static const double dashboardNotificationBadgePadding = 6;
  static const double dashboardNotificationBadgeOffset = -4;

  static const double dashboardStationIconSize = 56;
  static const double dashboardChangeStationIconSize = 14;

  static const double dashboardFinanceIconSize = 44;

  static const double dashboardNewRequestIconSize = 20;
  static const double dashboardNewRequestGasIconSize = 24;
  static const double dashboardNewRequestButtonPaddingH = 20;

  static const double dashboardOrderStatusBadgePaddingV = 6;
  static const double dashboardOrderStatusDotSize = 6;
  static const double dashboardOrderMetaRowGap = 6;
  static const double dashboardOrderProgressDiameter = 90;
  static const double dashboardOrderProgressStrokeWidth = 5;
  static const double dashboardOrderTruckIconSize = 20;
  static const double dashboardOrderDateHourIconSize = 12;
  static const double dashboardActionButtonHeight = 40;
  static const double dashboardActionButtonIconSize = 14;
  static const double dashboardActionButtonRadius = 8;
  static const double dashboardActionButtonPaddingH = 10;
  static const double dashboardActionButtonIconGap = 6;

  static const double dashboardStatCardPaddingH = 6;
  static const double dashboardStatCardPaddingV = 10;
  static const double dashboardStatCardRowGap = 6;

  static const double dashboardFuelTileHeight = 90;
  static const double dashboardFuelIconSize = 26;
  static const double dashboardFuelTilePadding = 6;
  static const double dashboardFuelIconRadius = 8;

  /// Pump geometry inside 'gas station.svg', as fractions of the icon box,
  /// so a fuel grade badge can be laid on the pump's face rather than the
  /// icon's centre.
  static const double dashboardPumpBodyLeft = 0.05;
  static const double dashboardPumpBodyWidth = 0.63;
  static const double dashboardPumpFaceTop = 0.42;
  static const double dashboardPumpFaceHeight = 0.50;

  // ---------------------------------------------------------------------
  // Order detail screen
  // ---------------------------------------------------------------------
  static const double orderTopBarBadgeSize = 20;
  static const double orderTopBarBadgeOffsetX = -4;
  static const double orderTopBarBadgeOffsetY = -6;
  static const double orderBackIconSize = 20;

  static const double orderReceiptAccentHeight = 3;
  static const double orderReceiptIconPadding = 6;
  static const double orderReceiptIconRadius = 8;

  static const double orderTransitIconGap = 10;
  static const double orderTransitButtonPaddingH = 6;

  static const double orderQrImageSize = 72;

  static const double orderCreditBadgeRadius = 6;
  static const double orderCreditIconPadding = 8;
  static const double orderCreditIconRadius = 10;
  static const double orderCreditProgressHeight = 6;
  static const double orderCreditProgressRadius = 4;

  static const double orderPrimaryActionHeight = 48;
  static const double orderCreditBannerGap = 20;
  static const double orderChipRadius = 8;
  static const double orderChipPaddingV = 6;

  // ---------------------------------------------------------------------
  // Create-order screen
  // ---------------------------------------------------------------------
  static const double orderTopBarIconSize = 22;
  static const double orderTopBarBadgeFontSize = 11;

  /// Selectable-tile border, on the grade/quantity/delivery pickers: 1.4pt
  /// once chosen, a hairline 1pt otherwise.
  static const double orderTileSelectedBorderWidth = 1.4;
  static const double orderTileBorderWidth = 1;

  static const double orderSectionGap = 20;
  static const double orderGradeTileHeight = 92;
  static const double orderFieldHeight = 62;

  /// The favourite-station, grade, quantity and delivery rows scroll
  /// horizontally rather than dividing the card between their tiles:
  /// sharing the width squeezed the labels down to an ellipsis
  /// ("As soon …"), so each tile is given the width its longest label needs
  /// and the row scrolls when they overflow.
  static const double orderFavouriteChipWidth = 130;
  static const double orderGradeTileWidth = 90;
  static const double orderQuantityFieldWidth = 118;
  static const double orderQuantityTileWidth = 86;
  static const double orderDeliveryTileWidth = 150;
  static const double orderStationArtSize = 64;
  static const double orderFavouriteChipRadius = 10;
  static const double orderConfirmButtonHeight = 56;

  static const double orderCodeBannerIconGap = 6;

  /// The `−`/`+` squares on the quantity counter, at the smallest reliable
  /// touch target.
  static const double orderQuantityStepperButtonSide = 44;

  /// The problem field on the support screen's report panel, and the square
  /// send button beside it — one constant so the two always match.
  static const double supportProblemFieldHeight = 56;
}
