package com.example.personal_finance

import android.content.res.Resources
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.personal_finance/flavor"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getFlavor") {
                val flavor = getFlavor()
                result.success(flavor)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getFlavor(): String {
        return try {
            val resources: Resources = resources
            val flavor = resources.getString(resources.getIdentifier("flavor", "string", packageName))
            flavor.ifEmpty { "dev" }
        } catch (e: Exception) {
            "dev"
        }
    }
}
