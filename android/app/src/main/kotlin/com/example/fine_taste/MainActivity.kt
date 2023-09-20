package com.finetaste.kalsan

import SplashView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "location_service").setMethodCallHandler { call, result ->
            if (call.method == "startBackgroundService") {
                startBackgroundService()
                result.success(null)
            }
        }
    }

    private fun startBackgroundService() {
        val serviceIntent = Intent(this, LocationService::class.java)
        startService(serviceIntent)
    }

    override fun provideSplashScreen(): SplashScreen? = SplashView()
}