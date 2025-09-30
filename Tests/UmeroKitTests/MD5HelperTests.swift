import Testing
import Foundation
import CryptoKit
@testable import UmeroKit

@Suite("MD5Helper Tests")
struct MD5HelperTests {

    @Test("MD5 hash matches original implementation")
    func md5HashMatchesOriginalImplementation() {
        // Test cases with known MD5 outputs
        let testCases = [
            ("", "d41d8cd98f00b204e9800998ecf8427e"),
            ("test", "098f6bcd4621d373cade4e832627b4f6"),
            ("The quick brown fox jumps over the lazy dog", "9e107d9d372bb6826bd81d3542a419d6"),
            ("api_keyTESTKEYmethodauth.getMobileSessionpasswordTESTPASSusernameUSERNAMESECRET", "adfc8f5f60de929cca024dfd4f586f74")
        ]

        for (input, expectedHash) in testCases {
            // Our new implementation
            let newHash = MD5Helper.hash(input)

            // Original implementation (inline for comparison)
            let data = Data(input.utf8)
            let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

            #expect(newHash == originalHash, "MD5Helper output doesn't match original for input: '\(input)'")
            #expect(newHash == expectedHash, "MD5 hash doesn't match expected value for input: '\(input)'")
        }
    }

    @Test("Last.fm signature format")
    func lastFmSignatureFormat() {
        // Test actual Last.fm signature format
        let apiKey = "testApiKey"
        let secret = "testSecret"
        let method = "auth.getMobileSession"
        let username = "testUser"
        let password = "testPass"

        // Build signature string as per Last.fm spec
        let signatureParameters = [
            "api_key": apiKey,
            "method": method,
            "password": password,
            "username": username
        ]

        var signature = ""
        for key in signatureParameters.keys.sorted() {
            signature += "\(key)\(signatureParameters[key]!)"
        }
        signature += secret

        // Test our helper
        let hash = MD5Helper.hash(signature)

        // Verify it's a valid 32-character hex string
        #expect(hash.count == 32)
        #expect(hash.allSatisfy { $0.isHexDigit })
    }
}