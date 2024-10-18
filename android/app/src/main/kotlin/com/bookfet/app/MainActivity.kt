package com.bookfet.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.bloctest/screen_security"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enableSecurity") {
                enableSecurity()
                result.success("Security enabled")
            } else if (call.method == "disableSecurity") {
                disableSecurity()
                result.success("Security disabled")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun enableSecurity() {
        window.setFlags(
            LayoutParams.FLAG_SECURE,
            LayoutParams.FLAG_SECURE
        )
    }

    private fun disableSecurity() {
        window.clearFlags(LayoutParams.FLAG_SECURE)
    }
}