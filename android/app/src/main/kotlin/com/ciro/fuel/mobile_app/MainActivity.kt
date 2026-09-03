package com.ciro.fuel.mobile_app

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Answers the same `com.ciro.fuel/maps` question the iOS side does, so the
 * Dart guard has one contract on both platforms: is a Maps API key actually
 * configured for this build?
 *
 * Android reads it from the manifest meta-data that `build.gradle.kts`
 * substitutes from `local.properties`. A missing key here does not abort the
 * process the way iOS does, but it still yields a blank, useless map — so
 * the same placeholder is the better answer.
 *
 * **Extends `FlutterFragmentActivity`, not `FlutterActivity`, and must keep
 * doing so** (spec 006 FR-013): `local_auth`'s Android implementation puts up
 * the system BiometricPrompt through the AndroidX fragment manager, so it
 * requires a `FragmentActivity` host. Under a plain `FlutterActivity` every
 * `authenticate()` call fails with `no_fragment_activity` — which
 * `BiometricAuthenticator` catches and degrades to "unavailable", so the app
 * lock and the login screen's biometric sign-in silently never work.
 */
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.ciro.fuel/maps",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAvailable" -> result.success(hasMapsApiKey())
                else -> result.notImplemented()
            }
        }
    }

    private fun hasMapsApiKey(): Boolean = try {
        val info = packageManager.getApplicationInfo(
            packageName,
            PackageManager.GET_META_DATA,
        )
        val key = info.metaData?.getString("com.google.android.geo.API_KEY")
        !key.isNullOrBlank()
    } catch (_: PackageManager.NameNotFoundException) {
        false
    }
}
