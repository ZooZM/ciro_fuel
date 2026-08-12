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

  /// Steps between (and beyond) the stops above. The settings, credit-limit,
  /// terms, stations and support screens are drawn on a rhythm the base
  /// scale does not cover; naming the gaps here keeps the literals out of
  /// the widget tree the same way the scale above does.
  static const double space6 = 6;
  static const double space10 = 10;
  static const double space14 = 14;
  static const double space18 = 18;
  static const double space20 = 20;
  static const double space28 = 28;
  static const double space40 = 40;
  static const double space48 = 48;

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

  /// The same idea for the settings list, which is a tab and so sits behind
  /// the nav bar — but shorter than [dashboardNavBarClearance], because it
  /// ends in a bordered button rather than a card that must clear fully.
  static const double moreListNavBarClearance = 100;
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

  /// Inline controls that sit *inside* a card — language chips, the support
  /// screen's call button, progress-bar tracks.
  static const double small = 8;

  /// Status pills and number badges (credit-limit status chips, terms
  /// clause numbers) — a step above [small] without reaching [tile].
  static const double badge = 10;
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
  static const double icon22 = 22;
  static const double icon24 = 24;
  static const double iconXl = 28;

  /// The smallest reliable touch target, and the side of the white rounded
  /// squares built around one — the top bar's buttons, the terms screen's
  /// back-to-top button, the stations avatar.
  static const double tapTarget = 44;

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
  static const double dashboardProfileImageSize = 48;
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
  static const double orderStationArtSize = 64;
  static const double orderFavouriteChipRadius = 10;
  static const double orderConfirmButtonHeight = 56;

  static const double orderCodeBannerIconGap = 6;

  /// Narrowest a quantity tile may get before the row rewraps. Four tiles
  /// across only reads on a normal phone; below this the section folds to
  /// two-per-row so "33,000 لتر" is never squeezed to an ellipsis.
  static const double orderQuantityTileMinWidth = 74;

  /// Tallest a delivery tile has to be to hold an icon over a two-line
  /// title and a two-line subtitle without clipping either.
  static const double orderDeliveryTileMinHeight = 116;

  /// The driver-notes well: a multi-line field, not the single squeezed
  /// line the first cut of the screen shipped with.
  static const double orderNotesFieldMinHeight = 96;
  static const int orderNotesMinLines = 3;
  static const int orderNotesMaxLines = 6;

  /// How long the receipt breakdown takes to fold away behind
  /// "إخفاء التفاصيل".
  static const Duration orderDetailsCollapseDuration = Duration(
    milliseconds: 220,
  );

  static const double orderInvoiceLogoHeight = 32;
  static const double orderPaymentLogoHeight = 34;
  static const double orderReceiptLogoHeight = 26;
  static const double orderCopyIconSize = 16;
  static const double orderInvoiceCopyIconSize = 18;
  static const double orderSealSize = 64;
  static const double orderSealIconSize = 30;
  static const double orderGaugeSize = 76;
  static const double orderGaugeStroke = 8;
  static const double orderGradePumpIconSize = 38;
  static const double orderConfirmPumpIconSize = 22;
  static const double orderStatIconSize = 36;
  static const double orderDriverPhotoSize = 54;
  static const double orderTruckImageWidth = 60;
  static const double orderTruckImageHeight = 36;
  static const double orderMapHeight = 300;
  static const double orderMapButtonSize = 48;
  static const double orderMapButtonGap = 10;
  static const double orderStepDotSize = 3;
  static const double orderStepTrackHeight = 8;
  static const double orderStepTrackRadius = 4;
  static const double orderStatusDotSize = 5;
  static const double orderDividerWidth = 14;

  /// The create-order form's sticky action bar frosts the content scrolling
  /// under it rather than hiding it behind an opaque panel.
  static const double orderActionBarBlur = 10;
  static const double orderActionBarOpacity = 0.8;

  // ---------------------------------------------------------------------
  // More / settings screen
  // ---------------------------------------------------------------------
  static const double moreProfileImageSize = 80;
  static const double moreListIconSize = 24;

  /// The profile card's green rule and code pill are drawn from the brand
  /// green held well back, so the card reads as tinted rather than outlined.
  static const double moreProfileBorderOpacity = 0.3;

  /// The notification switch is artwork rather than a Material [Switch], so
  /// only its width is set — its height follows the SVG's aspect ratio.
  static const double moreToggleWidth = 44;

  static const double moreLanguageRadioSize = 16;
  static const double moreLanguageRadioDotSize = 8;
  static const double moreLanguageRadioBorderWidth = 2;

  /// How long the notification switch cross-fades between its two artworks
  /// and the language section folds open — long enough to read as a change
  /// of state, short enough not to delay the next tap.
  static const Duration moreToggleDuration = Duration(milliseconds: 250);

  /// The chevron's rotation and the language chips' selection, both of which
  /// should land before [moreToggleDuration]'s fade finishes.
  static const Duration moreSelectionDuration = Duration(milliseconds: 200);

  // ---------------------------------------------------------------------
  // Credit-limit screen
  // ---------------------------------------------------------------------
  static const double creditIconTileSize = 44;

  /// The empty-state tile sits a size up from the header's [creditIconTileSize].
  static const double creditEmptyIconTileSize = 52;

  /// Wider than it is tall, as drawn — the two stepper keys flank a much
  /// taller amount column.
  static const double creditStepperButtonWidth = 52;
  static const double creditStepperButtonHeight = 44;
  static const double creditCheckBoxSize = 28;

  /// Untick an acknowledgement and the submit button dims to this rather
  /// than disappearing, so the form keeps its shape.
  static const double creditSubmitDisabledOpacity = 0.5;

  // ---------------------------------------------------------------------
  // Terms screen
  // ---------------------------------------------------------------------
  /// The ride back to the top of a long document — slower than a state
  /// change, so the reader can see how far they are being taken.
  static const Duration termsScrollToTopDuration = Duration(milliseconds: 400);

  /// Line height of the clause bodies. Justified Arabic paragraphs need the
  /// air; the acknowledgements on the credit-limit form are set tighter.
  static const double termsClauseLineHeight = 1.9;

  /// The clause number's badge is ruled in the brand blue held back, so it
  /// reads as a tint rather than an outline.
  static const double clauseBadgeOpacity = 0.4;
  static const double creditAcknowledgementLineHeight = 1.7;

  // ---------------------------------------------------------------------
  // Stations screen
  // ---------------------------------------------------------------------
  static const double stationsLastOrderArtSize = 72;
  static const double stationsProgressBarWidth = 80;
  static const double stationsProgressBarHeight = 8;
  static const double stationsStatusDotSize = 6;

  // ---------------------------------------------------------------------
  // Support screen
  // ---------------------------------------------------------------------
  static const double supportLogoHeight = 24;

  /// 'FUEL' is set beside the mark rather than under it, and the mark's own
  /// artwork carries empty space at the top — so the word is pushed down to
  /// sit on the mark's baseline instead of its bounding box.
  static const double supportBrandBaselineOffset = 15;
  static const double supportBrandLetterSpacing = 1.2;

  /// The wordmark is drawn tight, without the line box's usual leading.
  static const double supportBrandLineHeight = 1;

  static const double supportSocialIconSize = 24;
  static const double supportTopicIconSize = 20;
}
