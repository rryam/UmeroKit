import XCTest
import CryptoKit
@testable import UmeroKit

final class MD5VerificationTests: XCTestCase {
    
    func testExactByteByByteMatch() {
        // Test with various edge cases
        let testInputs = [
            // Empty string
            "",
            // Single character
            "a",
            // Whitespace
            " ",
            "\t",
            "\n",
            "\r\n",
            // Special characters
            "!@#$%^&*()",
            // Unicode
            "🎵",
            "こんにちは",
            "Ñoño",
            // Long strings
            String(repeating: "a", count: 1000),
            // Binary-like data
            "\u{0}\u{1}\u{2}\u{3}\u{4}\u{5}",
            // Last.fm specific patterns
            "api_key123method456",
            "track.loveapi_keyXXXartistTest&Artistsk123trackTest's Track",
            // URL encoding edge cases
            "Test & Artist",
            "100% Pure",
            "Artist/Track",
            "Track (Live)",
            // Null bytes
            "before\u{0}after",
            // High unicode
            "𝕳𝖊𝖑𝖑𝖔",
            // Combining characters
            "é", // é as single character
            "é", // e + combining accent
        ]
        
        for input in testInputs {
            // Original implementation
            let data = Data(input.utf8)
            let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
            
            // New implementation
            let newHash = MD5Helper.hash(input)
            
            XCTAssertEqual(newHash, originalHash, 
                          "Mismatch for input: '\(input.debugDescription)' " +
                          "(length: \(input.count), utf8 bytes: \(data.count))")
        }
    }
    
    func testLastFmRealWorldScenarios() {
        // Test actual Last.fm API signature scenarios
        struct TestCase {
            let description: String
            let params: [String: String]
            let secret: String
        }
        
        let testCases = [
            TestCase(
                description: "Basic auth",
                params: [
                    "method": "auth.getMobileSession",
                    "username": "test_user",
                    "password": "p@ssw0rd!",
                    "api_key": "1234567890abcdef"
                ],
                secret: "secret123"
            ),
            TestCase(
                description: "Track with special characters",
                params: [
                    "method": "track.scrobble",
                    "artist": "Guns N' Roses",
                    "track": "Sweet Child O' Mine",
                    "timestamp": "1234567890",
                    "api_key": "xyz",
                    "sk": "session123"
                ],
                secret: "sec"
            ),
            TestCase(
                description: "Unicode artist/track",
                params: [
                    "method": "track.love",
                    "artist": "Björk",
                    "track": "Jóga",
                    "api_key": "key",
                    "sk": "sk"
                ],
                secret: "secret"
            )
        ]
        
        for testCase in testCases {
            var signature = ""
            for key in testCase.params.keys.sorted() {
                signature += "\(key)\(testCase.params[key]!)"
            }
            signature += testCase.secret
            
            // Both implementations
            let data = Data(signature.utf8)
            let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
            let newHash = MD5Helper.hash(signature)
            
            XCTAssertEqual(newHash, originalHash,
                          "Mismatch for scenario: \(testCase.description)")
        }
    }
    
    func testThreadSafety() {
        // Ensure MD5Helper is thread-safe
        let expectation = XCTestExpectation(description: "Concurrent MD5 hashing")
        let iterations = 1000
        let testString = "concurrent_test_string"
        
        let data = Data(testString.utf8)
        let expectedHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        
        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            let hash = MD5Helper.hash(testString)
            XCTAssertEqual(hash, expectedHash)
        }
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testMemoryBehavior() {
        // Test with large inputs to ensure no memory issues
        let largeString = String(repeating: "a", count: 1_000_000)
        
        let data = Data(largeString.utf8)
        let originalHash = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        let newHash = MD5Helper.hash(largeString)
        
        XCTAssertEqual(newHash, originalHash)
    }
}