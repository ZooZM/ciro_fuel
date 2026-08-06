import 'package:flutter/widgets.dart';

/// The locales the app ships translations for. Arabic is the fallback
/// because Ciro's primary market is Saudi Arabia — an unrecognised device
/// locale should land on Arabic, not English.
abstract final class AppLocales {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static const Locale fallback = arabic;
  static const List<Locale> supported = [arabic, english];

  /// The language pill toggles rather than opening a picker, since there
  /// are exactly two locales. Extend this to a picker if a third is added.
  static Locale next(Locale current) =>
      current.languageCode == arabic.languageCode ? english : arabic;
}
