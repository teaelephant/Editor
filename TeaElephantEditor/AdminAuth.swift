//
//  AdminAuth.swift
//  TeaElephantEditor
//
//  Admin authentication helper for JWT generation and keychain management
//

import Foundation
import Security
import CryptoKit

enum AdminAuthError: Error {
    case keychainLookupFailed(OSStatus)
    case keyExportFailed
    case keyImportFailed
    case jwtGenerationFailed
    case invalidKeyData
}

class AdminAuth {
    private static let keychainLabel = "com.teaelephant.editor.adminkey"
    private static let keychainService = "TeaElephantEditor"
    private static let keychainAccount = "admin"

    // Load private key from Keychain as SecKey, then convert to CryptoKit key
    static func loadPrivateKeyFromKeychain() throws -> P256.Signing.PrivateKey {
        // Query for the private key by label
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrLabel as String: keychainLabel,
            kSecReturnRef as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else {
            throw AdminAuthError.keychainLookupFailed(status)
        }

        guard let secKey = (item as! SecKey?) else {
            throw AdminAuthError.keychainLookupFailed(errSecItemNotFound)
        }

        // Export the key data from SecKey
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(secKey, &error) as Data? else {
            throw AdminAuthError.keyExportFailed
        }

        // CryptoKit expects x963 representation for P256
        // SecKey exports in x963 format for EC keys, so we can use it directly
        guard let privateKey = try? P256.Signing.PrivateKey(x963Representation: keyData) else {
            throw AdminAuthError.invalidKeyData
        }

        return privateKey
    }

    // Import private key from PEM file into Keychain (one-time setup)
    static func importPrivateKeyFromPEM(pemData: Data) throws {
        // Parse PEM format
        let pemString = String(data: pemData, encoding: .utf8) ?? ""
        let base64String = pemString
            .replacingOccurrences(of: "-----BEGIN EC PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END EC PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let keyData = Data(base64Encoded: base64String) else {
            throw AdminAuthError.invalidKeyData
        }

        // Create SecKey from raw data
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 256
        ]

        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            throw AdminAuthError.keyImportFailed
        }

        // Store in keychain
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrLabel as String: keychainLabel,
            kSecAttrApplicationLabel as String: keychainService,
            kSecValueRef as String: secKey
        ]

        // Delete existing key first
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrLabel as String: keychainLabel
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AdminAuthError.keychainLookupFailed(status)
        }
    }

    static func generateAdminJWT() -> String? {
        // Load private key from Keychain
        guard let privateKey = try? loadPrivateKeyFromKeychain() else {
            print("Failed to load private key from Keychain")
            return nil
        }

        // Create JWT header with key ID for rotation support
        let header: [String: Any] = [
            "alg": "ES256",
            "typ": "JWT",
            "kid": "admin-key-v1"  // Key ID for rotation
        ]

        let now = Date()
        let expiration = now.addingTimeInterval(24 * 60 * 60) // 24 hours
        let notBefore = now.addingTimeInterval(-60) // Valid from 1 minute ago (clock skew)

        let claims: [String: Any] = [
            "admin": true,
            "iss": "TeaElephantEditor",
            "aud": "tea-elephant-api",
            "iat": Int(now.timeIntervalSince1970),
            "nbf": Int(notBefore.timeIntervalSince1970),
            "exp": Int(expiration.timeIntervalSince1970),
            "jti": UUID().uuidString
        ]

        // Encode header and claims
        guard let headerData = try? JSONSerialization.data(withJSONObject: header),
              let claimsData = try? JSONSerialization.data(withJSONObject: claims) else {
            return nil
        }

        let headerB64 = headerData.base64URLEncodedString()
        let claimsB64 = claimsData.base64URLEncodedString()

        let message = "\(headerB64).\(claimsB64)"
        guard let messageData = message.data(using: .utf8) else {
            return nil
        }

        // Sign with private key
        guard let signature = try? privateKey.signature(for: SHA256.hash(data: messageData)) else {
            return nil
        }
        let signatureB64 = signature.rawRepresentation.base64URLEncodedString()

        return "\(message).\(signatureB64)"
    }
}

extension Data {
    func base64URLEncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
