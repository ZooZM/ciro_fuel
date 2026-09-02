import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Whether `GMSServices.provideAPIKey` actually ran. Dart asks before it
  /// builds a map: constructing one without this having happened raises an
  /// NSException inside `+[GMSServices checkServicePreconditions]`, which
  /// aborts the process — there is no catching it from Dart, so the only
  /// defence is not to create the map.
  private var mapsInitialized = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
      !apiKey.isEmpty
    {
      GMSServices.provideAPIKey(apiKey)
      mapsInitialized = true
    } else {
      // Skipping initialization does not make the SDK safe — it makes the
      // first GMSMapView abort the process, which reaches the developer as
      // a bare "Lost connection to device" on the tracking screen with no
      // hint of the cause. Say so here, where it is still diagnosable.
      NSLog(
        """
        [CiroFuel] GOOGLE_MAPS_API_KEY is not set — Google Maps is NOT initialized.
        Create ios/Flutter/Secrets.xcconfig from Secrets.example.xcconfig and set
        GOOGLE_MAPS_API_KEY, then run with a matching
        --dart-define=GOOGLE_MAPS_API_KEY=... (see README). The tracking screen
        renders a placeholder instead of the map until both are set.
        """)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.ciro.fuel/maps",
      binaryMessenger: engineBridge.applicationRegistrar.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "isAvailable":
        result(self?.mapsInitialized ?? false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
