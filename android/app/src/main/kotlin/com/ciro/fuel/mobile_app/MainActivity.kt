package com.ciro.fuel.mobile_app

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
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
 */
class MainActivity : FlutterActivity() {
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
