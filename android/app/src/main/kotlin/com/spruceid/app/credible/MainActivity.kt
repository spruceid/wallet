package com.spruceid.app.credible

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity : FlutterFragmentActivity() {
    private val keymanChannelId = "com.security.keyman"
    private val urlIntentChannelId = "com.intent.url"
    private lateinit var urlIntentContent: String
    private lateinit var keymanChannel: MethodChannel
    private lateinit var urlIntentChannel: MethodChannel


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        keymanChannel = MethodChannel(flutterEngine.dartExecutor, keymanChannelId)
        urlIntentChannel = MethodChannel(flutterEngine.dartExecutor, urlIntentChannelId)

        urlIntentChannel.setMethodCallHandler { _, result ->
            if (this::urlIntentContent.isInitialized) {
                Log.i("SpruceKit Wallet", "Url Intent Content $urlIntentContent")
                val ret = urlIntentContent
                urlIntentContent = ""
                result.success(ret)
            } else {
                Log.i("SpruceKit Wallet", "Url Intent Content not initialized")
                result.success("Url Intent string not initialized")
            }
        }

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
                        result.success(true)
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
                        result.success(true)
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
    }

    private fun handleUrlIntent(tag: String, intent: Intent?) {
        Log.i("SpruceKit Wallet", "$tag - Intent: $intent")

        val list = intent?.extras?.keySet()?.map { it to (intent.extras?.get(it) ?: "null") }

        Log.i("SpruceKit Wallet", "$tag - Intent Data: ${intent?.data}")
        Log.i("SpruceKit Wallet", "$tag - Intent Data String: ${intent?.dataString}")
        Log.i("SpruceKit Wallet", "$tag - Intent Type: ${intent?.type}")
        Log.i("SpruceKit Wallet", "$tag - Intent Extras: $list")

        when (intent?.action) {
            Intent.ACTION_VIEW -> {
                if (intent.dataString != null) {
                    urlIntentContent = intent.dataString!!
                }
            }
        }
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleUrlIntent("onNewIntent", intent)
    }
}
