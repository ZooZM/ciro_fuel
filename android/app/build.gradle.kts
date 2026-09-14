import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Google Maps API key: never committed. Set `googleMaps.apiKey=…` in
// android/local.properties (gitignored) or pass -PgoogleMapsApiKey=… on the CLI.
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}
val googleMapsApiKey: String =
    (project.findProperty("googleMapsApiKey") as String?)
        ?: localProperties.getProperty("googleMaps.apiKey")
        ?: ""

android {
    namespace = "com.ciro.fuel.mobile_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by `flutter_local_notifications` (^18.0.1), which spec 011
        // added for the driver's stop prompt — the one notification that must
        // reach a driver who is mid-drive with the app backgrounded.
        //
        // Without this the Android build fails outright at
        // `:app:checkDebugAarMetadata` ("requires core library desugaring to be
        // enabled"), so the app could not be assembled for a device at all.
        // Nothing caught it: `flutter test` runs Dart on the host JVM and never
        // invokes Gradle, so the entire suite passes on a project that cannot
        // produce an APK.
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.ciro.fuel.mobile_app"
        // Android 8.0+ per plan Technical Context (required for foreground-service
        // location type used during an active delivery, research R4).
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // The desugaring runtime the `compileOptions` flag above needs. 2.1.4 is the
    // minimum `flutter_local_notifications` 18.x accepts.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
