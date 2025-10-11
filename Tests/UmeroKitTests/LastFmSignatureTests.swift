import Testing
import Foundation
import CryptoKit
@testable import UmeroKit

@Suite("Last.fm Signature Tests")
struct LastFmSignatureTests {

    @Test("Last.fm auth signature generation")
    func lastFmAuthSignatureGeneration() {
        // Test the exact signature generation as used in UAuthDataRequest
        let apiKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        let secret = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
        let username = "testuser"
        let password = "testpassword"
        let method = "auth.getMobileSession"

        // This is exactly how UAuthDataRequest builds the signature
        let signatureParameters = [
            "method": method,
            "api_key": apiKey,
            "password": password,
            "username": username
        ]

        var signature = ""
        for key in signatureParameters.keys.sorted() {
            signature += "\(key)\(signatureParameters[key]!)"
        }
        signature += secret

        // Generate hash using our MD5Helper
        let hash = MD5Helper.hash(signature)

        // Also generate using the original inline method to ensure they match
        let data = Data(signature.utf8)
        let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

        #expect(hash == originalHash, "MD5Helper must produce identical output to original implementation")
        #expect(hash.count == 32, "MD5 hash must be 32 characters")
        #expect(hash.allSatisfy { $0.isHexDigit }, "MD5 hash must be all hex digits")
    }

    @Test("Scrobbling signature generation")
    func scrobblingSignatureGeneration() {
        // Test scrobbling signature (includes timestamp)
        let apiKey = "testApiKey"
        let secret = "testSecret"
        let track = "Test Track"
        let artist = "Test Artist"
        let sessionKey = "testSessionKey"
        let timestamp = "1234567890"

        let parameters = [
            "method": "track.scrobble",
            "api_key": apiKey,
            "artist": artist,
            "track": track,
            "sk": sessionKey,
            "timestamp": timestamp
        ]

        var signature = ""
        for key in parameters.keys.sorted() {
            signature += "\(key)\(parameters[key]!)"
        }
        signature += secret

        let hash = MD5Helper.hash(signature)

        // Verify format
        #expect(hash.count == 32)
        #expect(hash.allSatisfy { $0.isHexDigit })
    }

    @Test("Special characters in signature", arguments: [
        "Test & Artist",
        "Test's Track",
        "Track (feat. Someone)",
        "Artist/Track",
        "Test + Plus",
        "Ümläüts"
    ])
    func specialCharactersInSignature(testString: String) {
        let hash = MD5Helper.hash(testString)

        // Verify the hash is valid
        #expect(hash.count == 32, "Hash for '\(testString)' should be 32 chars")
        #expect(hash.allSatisfy { $0.isHexDigit }, "Hash for '\(testString)' should be all hex")

        // Compare with original implementation
        let data = Data(testString.utf8)
        let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        #expect(hash == originalHash, "Hash for '\(testString)' must match original")
    }
}
