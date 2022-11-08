package com.spruceid.app.credible

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterFragmentActivity() {
    private val channelId = "com.web.share"
    private lateinit var webShareContent: String
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor, channelId)

        channel.setMethodCallHandler { _, result ->
            // For now always reply with the web share string - ignore any method
            if (this::webShareContent.isInitialized) {
                result.success(webShareContent)
            } else {
                result.success("Web Share string not initialized")
            }
        }

        when {
            intent?.action == Intent.ACTION_SEND -> {
                if ("text/plain" == intent.type) {
                    handleSendText(intent)
                }
            }
        }
    }

    private fun handleSendText(intent: Intent) {
        intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
            contentResolver.openInputStream(uri)?.use {
                stream -> stream.bufferedReader().use {
                    webShareContent = it.readText()
                }
            }
        }
//        intent.getStringExtra(Intent.EXTRA_TEXT)?.let {
//            // Store the web shared link for later use.
//            webShareContent = it
//        }
    }
}
