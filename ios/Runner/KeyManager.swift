import Flutter
import CoreFoundation

class KeyManager: NSObject {
    static func generateSigningKey(id: String) {
        let tag = id.data(using: .utf8)!
        
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            nil)!
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: NSNumber(value: 256),
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tag,
                kSecAttrAccessControl as String: access,
            ]
        ]
        
        var error: Unmanaged<CFError>?
        SecKeyCreateRandomKey(attributes as CFDictionary, &error)
    }
    
    static func keyExists(id: String) {
        let tag = id.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnRef as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
    }

    static func getJwk() {
        // get SecKey
        // obtain w(x, y) from SecKey
        // base64Url NO_PAD, NO_WRAP
        // {kty: 'EC', crv: 'P-256', x:'', y:''}
    }
    
    static func signPayload(id: String, payload: [UInt8]) -> [UInt8]? {
        let tag = id.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        let key = item as! SecKey
        
        guard let data = CFDataCreate(kCFAllocatorDefault, payload, payload.count) else {
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureDigestX962SHA256
        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(
            key,
            algorithm,
            data,
            &error
        ) as Data? else {
            return nil
        }
        
        return [UInt8](signature)
    }
    
    static func generateEncryptionKey(id: String)  {
        let tag = id.data(using: .utf8)!
        
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .privateKeyUsage,
            nil)!
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: NSNumber(value: 256),
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tag,
                kSecAttrAccessControl as String: access,
            ]
        ]
        
        var error: Unmanaged<CFError>?
        SecKeyCreateRandomKey(attributes as CFDictionary, &error)
    }
    
    static func encryptPayload(id: String, payload: [UInt8]) -> ([UInt8], [UInt8])? {
        let tag = id.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        let key = item as! SecKey
        guard let publicKey = SecKeyCopyPublicKey(key) else {
            return nil
        }
        guard let data = CFDataCreate(kCFAllocatorDefault, payload, payload.count) else {
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA512AESGCM
        var error: Unmanaged<CFError>?
        guard let encrypted = SecKeyCreateEncryptedData(
            publicKey,
            algorithm,
            data,
            &error
        ) as Data? else {
            return nil
        }
        
        return ([0], [UInt8](encrypted))
    }
    
    static func decryptPayload(id: String, iv: [UInt8], payload: [UInt8]) -> [UInt8]? {
        let tag = id.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        let key = item as! SecKey
        
        guard let data = CFDataCreate(kCFAllocatorDefault, payload, payload.count) else {
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorX963SHA512AESGCM
        var error: Unmanaged<CFError>?
        guard let decrypted = SecKeyCreateDecryptedData(
            key,
            algorithm,
            data,
            &error
        ) as Data? else {
            return nil
        }
        
        return [UInt8](decrypted)
    }
}
