import XCTest
import CryptoKit
@testable import UmeroKit

final class LastFmSignatureTests: XCTestCase {
    
    func testLastFmAuthSignatureGeneration() {
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
        
        XCTAssertEqual(hash, originalHash, "MD5Helper must produce identical output to original implementation")
        XCTAssertEqual(hash.count, 32, "MD5 hash must be 32 characters")
        XCTAssertTrue(hash.allSatisfy { $0.isHexDigit }, "MD5 hash must be all hex digits")
    }
    
    func testScrobblingSignatureGeneration() {
        // Test scrobbling signature (includes timestamp)
        let apiKey = "testApiKey"
        let secret = "testSecret"
        let track = "Test Track"
        let artist = "Test Artist"
        let sessionKey = "testSessionKey"
        let timestamp = "1234567890"
        
        var parameters = [
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
        XCTAssertEqual(hash.count, 32)
        XCTAssertTrue(hash.allSatisfy { $0.isHexDigit })
    }
    
    func testSpecialCharactersInSignature() {
        // Test with special characters that might appear in track/artist names
        let testCases = [
            "Test & Artist",
            "Test's Track",
            "Track (feat. Someone)",
            "Artist/Track",
            "Test + Plus",
            "Ümläüts"
        ]
        
        for testString in testCases {
            let hash = MD5Helper.hash(testString)
            
            // Verify the hash is valid
            XCTAssertEqual(hash.count, 32, "Hash for '\(testString)' should be 32 chars")
            XCTAssertTrue(hash.allSatisfy { $0.isHexDigit }, "Hash for '\(testString)' should be all hex")
            
            // Compare with original implementation
            let data = Data(testString.utf8)
            let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
            XCTAssertEqual(hash, originalHash, "Hash for '\(testString)' must match original")
        }
    }
}