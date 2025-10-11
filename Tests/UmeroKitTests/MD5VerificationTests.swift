import Testing
import Foundation
import CryptoKit
@testable import UmeroKit

@Suite("MD5 Verification Tests")
struct MD5VerificationTests {

  private struct RealWorldTestCase {
    let description: String
    let params: [String: String]
    let secret: String
  }

  private static let realWorldTestCases: [RealWorldTestCase] = [
    RealWorldTestCase(
      description: "Basic auth",
      params: [
        "method": "auth.getMobileSession",
        "username": "test_user",
        "password": "p@ssw0rd!",
        "api_key": "1234567890abcdef"
      ],
      secret: "secret123"
    ),
    RealWorldTestCase(
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
    RealWorldTestCase(
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

  @Test("Exact byte-by-byte match", arguments: [
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
    "é" // e + combining accent
  ])
  func exactByteByByteMatch(input: String) {
    // Original implementation
    let data = Data(input.utf8)
    let originalHash = Insecure.MD5.hash(data: data)
      .map { String(format: "%02hhx", $0) }
      .joined()

    // New implementation
    let newHash = MD5Helper.hash(input)

    let message = """
    Mismatch for input: '\(input.debugDescription)' \
    (length: \(input.count), utf8 bytes: \(data.count))
    """
    #expect(newHash == originalHash, Comment(rawValue: message))
  }

  @Test("Last.fm real-world scenarios")
  func lastFmRealWorldScenarios() {
    for testCase in Self.realWorldTestCases {
      var signature = ""
      for key in testCase.params.keys.sorted() {
        signature += "\(key)\(testCase.params[key]!)"
      }
      signature += testCase.secret

      // Both implementations
      let data = Data(signature.utf8)
      let originalHash = Insecure.MD5.hash(data: data)
        .map { String(format: "%02hhx", $0) }
        .joined()
      let newHash = MD5Helper.hash(signature)

      #expect(
        newHash == originalHash,
        "Mismatch for scenario: \(testCase.description)"
      )
    }
  }

  @Test("Memory behavior with large input")
  func memoryBehavior() {
    // Test with large inputs to ensure no memory issues
    let largeString = String(repeating: "a", count: 1_000_000)

    let data = Data(largeString.utf8)
    let originalHash = Insecure.MD5.hash(data: data)
      .map { String(format: "%02hhx", $0) }
      .joined()
    let newHash = MD5Helper.hash(largeString)

    #expect(newHash == originalHash)
  }
}
