import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Session persistence (FR-002): Keychain on iOS, Keystore-backed encrypted
/// storage on Android. v1 has no biometric/PIN app-lock on top of this
/// (clarification 2026-07-20).
class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'auth.accessToken';
  static const _refreshTokenKey = 'auth.refreshToken';

  final FlutterSecureStorage _storage;

  Future<String?> get accessToken => _storage.read(key: _accessTokenKey);

  Future<String?> get refreshToken => _storage.read(key: _refreshTokenKey);

  Future<void> save({required String access, required String refresh}) =>
      Future.wait([
        _storage.write(key: _accessTokenKey, value: access),
        _storage.write(key: _refreshTokenKey, value: refresh),
      ]);

  Future<void> clear() => Future.wait([
    _storage.delete(key: _accessTokenKey),
    _storage.delete(key: _refreshTokenKey),
  ]);

  Future<bool> get hasSession async => (await refreshToken) != null;
}
