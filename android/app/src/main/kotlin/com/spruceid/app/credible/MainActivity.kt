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

    private val keymanChannelId = "com.security.keyman"
    private lateinit var keymanChannel: MethodChannel

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

        keymanChannel = MethodChannel(flutterEngine.dartExecutor, keymanChannelId)

        keymanChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "keyExists" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        val exists = keyExists(alias)
                        result.success(exists)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_KEY-EXISTS", "", null)
                    }
                }
                "getJwk" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        val jwk = getJwk(alias)
                        result.success(jwk)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_GET-JWK", "", null)
                    }

                }
                "generateSigningKey" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        generateSigningKey(alias)
                        result.success(null)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_GEN-SIG-KEY", "", null)
                    }
                }
                "signPayload" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        val payload = call.argument<ByteArray>("payload")!!
                        val signed = signPayload(alias, payload)
                        result.success(signed)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_SIGN", "", null)
                    }
                }
                "generateEncryptionKey" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        generateEncryptionKey(alias)
                        result.success(null)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_GEN-ENC-KEY", "", null)
                    }
                }
                "encryptPayload" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        val payload = call.argument<ByteArray>("payload")!!
                        val (iv, encrypted) = encryptPayload(alias, payload)!!
                        result.success(listOf(iv, encrypted))
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_ENC", "", null)
                    }
                }
                "decryptPayload" -> {
                    try {
                        val alias = call.argument<String>("alias")!!
                        val iv = call.argument<ByteArray>("iv")!!
                        val payload = call.argument<ByteArray>("payload")!!
                        val decrypted = decryptPayload(alias, iv, payload)!!
                        result.success(decrypted)
                    } catch (e: Exception) {
                        Log.d("KEYMAN", "$e")
                        result.error("KEYMAN_ENC", "", null)
                    }
                }
            }
        }

        Log.d("KEYMAN", "$intent")

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
