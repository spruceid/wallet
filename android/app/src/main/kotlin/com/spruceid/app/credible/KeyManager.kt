package com.spruceid.app.credible

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import androidx.annotation.RequiresApi
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.Signature
import java.security.interfaces.ECPublicKey
import java.security.spec.ECGenParameterSpec
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

private fun getKeyStore(): KeyStore {
    return KeyStore.getInstance("AndroidKeyStore").apply {
        load(null)
    }
}

private fun getSecretKey(id: String): SecretKey? {
    val ks = getKeyStore()

    val entry: KeyStore.Entry = ks.getEntry(id, null)
    if (entry !is KeyStore.SecretKeyEntry) {
        Log.w("KEYMAN", "Not an instance of a SecretKeyEntry")
        return null
    }

    return entry.secretKey
}

fun reset() {
    val ks = getKeyStore()
    ks.aliases().iterator().forEach {
        ks.deleteEntry(it)
    }
}

fun generateSigningKey(id: String) {
    val generator = KeyPairGenerator.getInstance(
        KeyProperties.KEY_ALGORITHM_EC,
        "AndroidKeyStore",
    );

    val spec = KeyGenParameterSpec.Builder(
        id,
        KeyProperties.PURPOSE_SIGN
                or KeyProperties.PURPOSE_VERIFY,
    )
        .setDigests(KeyProperties.DIGEST_SHA256, KeyProperties.DIGEST_SHA512)
        .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
        .build()

    generator.initialize(spec)
    generator.generateKeyPair()
}

private fun clampOrFill(input: ByteArray) : ByteArray {
    // Assumes the value above 32 will always be 33.
    // BigInteger will add an extra byte to keep the number positive.
    // But the key values will always be 32 bytes.
    return if (input.size > 32) {
        input.drop(1).toByteArray()
    } else if (input.size < 32) {
        List(32 - input.size){ 0.toByte() }.toByteArray() + input
    } else {
        input
    }
}

fun getJwk(id: String): String? {
    val ks = getKeyStore()
    val key = ks.getEntry(id, null)

    if (key is KeyStore.PrivateKeyEntry) {
        if (key.certificate.publicKey is ECPublicKey) {
            val ecPublicKey = key.certificate.publicKey as ECPublicKey
            val x = Base64.encodeToString(
                clampOrFill(ecPublicKey.w.affineX.toByteArray()),
                Base64.URL_SAFE
                        xor Base64.NO_PADDING
                        xor Base64.NO_WRAP
            )
            val y = Base64.encodeToString(
                clampOrFill(ecPublicKey.w.affineY.toByteArray()),
                Base64.URL_SAFE
                        xor Base64.NO_PADDING
                        xor Base64.NO_WRAP
            )

            return """{"kty":"EC","crv":"P-256","x":"$x","y":"$y"}"""
        }
    }

    return null
}

fun keyExists(id: String): Boolean {
    val ks = getKeyStore()
    return ks.containsAlias(id) && ks.isKeyEntry(id)
}

fun signPayload(id: String, payload: ByteArray): ByteArray? {
    val ks = getKeyStore()
    val entry: KeyStore.Entry = ks.getEntry(id, null)
    if (entry !is KeyStore.PrivateKeyEntry) {
        Log.w("KEYMAN", "Not an instance of a PrivateKeyEntry")
        return null
    }

    return Signature.getInstance("SHA256withECDSA").run {
        initSign(entry.privateKey)
        update(payload)
        sign()
    }
}

fun generateEncryptionKey(id: String) {
    val generator = KeyGenerator.getInstance(
        KeyProperties.KEY_ALGORITHM_AES,
        "AndroidKeyStore",
    );

    val spec = KeyGenParameterSpec.Builder(
        id,
        KeyProperties.PURPOSE_ENCRYPT
                or KeyProperties.PURPOSE_DECRYPT,
    )
        .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
        .build()

    generator.init(spec)
    generator.generateKey()
}

fun encryptPayload(id: String, payload: ByteArray): Pair<ByteArray, ByteArray>? {
    val secretKey = getSecretKey(id)

    val cipher = Cipher.getInstance("AES/GCM/NoPadding");
    cipher.init(Cipher.ENCRYPT_MODE, secretKey);
    val iv = cipher.iv
    val encrypted = cipher.doFinal(payload)
    return Pair(iv, encrypted)
}

fun decryptPayload(id: String, iv: ByteArray, payload: ByteArray): ByteArray? {
    val secretKey = getSecretKey(id)
    val cipher = Cipher.getInstance("AES/GCM/NoPadding");
    val spec = GCMParameterSpec(128, iv)
    cipher.init(Cipher.DECRYPT_MODE, secretKey, spec)
    return cipher.doFinal(payload)
}
