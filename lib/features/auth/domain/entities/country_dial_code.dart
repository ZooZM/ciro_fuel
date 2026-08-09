/// The country dialling codes the login screen offers, with just enough
/// metadata to validate a national number and compose an E.164 identifier.
///
/// Deliberately a closed enum rather than a full country database: Ciro
/// operates in the Gulf, and an exhaustive list would be dead weight plus a
/// localisation burden (country names in two languages) for no gain.
enum CountryDialCode {
  saudiArabia('SA', '+966', 9, 'السعودية', '🇸🇦'),
  unitedArabEmirates('AE', '+971', 9, 'الإمارات', '🇦🇪'),
  kuwait('KW', '+965', 8, 'الكويت', '🇰🇼'),
  bahrain('BH', '+973', 8, 'البحرين', '🇧🇭'),
  qatar('QA', '+974', 8, 'قطر', '🇶🇦'),
  oman('OM', '+968', 8, 'عُمان', '🇴🇲'),
  egypt('EG', '+20', 10, 'مصر', '🇪🇬');

  const CountryDialCode(
    this.isoCode,
    this.dialCode,
    this.nationalNumberLength,
    this.nameAr,
    this.flag,
  );

  /// ISO 3166-1 alpha-2, used as the stable key when persisting a choice.
  final String isoCode;

  /// E.164 country calling code, including the leading `+`.
  final String dialCode;

  /// Digits expected after the dialling code, trunk prefix excluded.
  final int nationalNumberLength;

  /// Arabic name of the country.
  final String nameAr;

  /// Emoji flag of the country.
  final String flag;

  static const CountryDialCode fallback = CountryDialCode.saudiArabia;

  static CountryDialCode? fromIsoCode(String? isoCode) {
    if (isoCode == null) return null;
    for (final code in values) {
      if (code.isoCode == isoCode) return code;
    }
    return null;
  }

  /// Strips everything the user may have typed for readability (spaces,
  /// dashes) plus the national trunk prefix `0`, which E.164 omits.
  static String normalizeNationalNumber(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.startsWith('0') ? digitsOnly.substring(1) : digitsOnly;
  }

  bool isValidNationalNumber(String input) =>
      normalizeNationalNumber(input).length == nationalNumberLength;

  /// Composes the E.164 identifier the API authenticates against, e.g.
  /// `05X XXX XXXX` under [saudiArabia] becomes `+9665XXXXXXX`.
  String toE164(String nationalNumber) =>
      '$dialCode${normalizeNationalNumber(nationalNumber)}';
}
