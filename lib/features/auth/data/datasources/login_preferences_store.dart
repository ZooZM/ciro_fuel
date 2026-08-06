import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/country_dial_code.dart';

/// The phone number a returning user asked us to remember.
class RememberedLogin {
  const RememberedLogin({required this.country, required this.nationalNumber});

  final CountryDialCode country;
  final String nationalNumber;
}

/// Backs the "remember me" checkbox.
///
/// Only the *identifier* is kept — never the password. Even so it lives in
/// secure storage alongside [TokenStore] rather than in plain preferences,
/// because a phone number is personal data.
class LoginPreferencesStore {
  LoginPreferencesStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _countryKey = 'login.rememberedCountry';
  static const _phoneKey = 'login.rememberedPhone';

  final FlutterSecureStorage _storage;

  Future<RememberedLogin?> read() async {
    final phone = await _storage.read(key: _phoneKey);
    if (phone == null || phone.isEmpty) return null;

    final country =
        CountryDialCode.fromIsoCode(await _storage.read(key: _countryKey)) ??
        CountryDialCode.fallback;
    return RememberedLogin(country: country, nationalNumber: phone);
  }

  Future<void> save({
    required CountryDialCode country,
    required String nationalNumber,
  }) => Future.wait([
    _storage.write(key: _countryKey, value: country.isoCode),
    _storage.write(key: _phoneKey, value: nationalNumber),
  ]);

  Future<void> clear() => Future.wait([
    _storage.delete(key: _countryKey),
    _storage.delete(key: _phoneKey),
  ]);
}
