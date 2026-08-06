/// Build-time configuration, injected via `--dart-define`. No secrets are
/// committed; see `README.md` for the exact `flutter run` invocation.
///
/// The defaults target the feature-001 backend running on the developer's own
/// machine (`npm run start:dev`, port 3000). `localhost` is correct for the iOS
/// simulator, macOS and Chrome, which share the host's network stack; an
/// Android emulator needs `10.0.2.2` and a physical device the host's LAN IP,
/// both supplied via `--dart-define` rather than by editing this file.
abstract final class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
}
