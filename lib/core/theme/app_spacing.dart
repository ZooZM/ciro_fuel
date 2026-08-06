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
}

/// Corner radii, named by the component they belong to rather than by size,
/// so intent survives a redesign.
abstract final class AppRadii {
  static const double field = 14;
  static const double sheet = 20;
  static const double chip = 20;
  static const double pill = 28;
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
}
