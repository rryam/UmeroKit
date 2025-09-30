import Testing
import Foundation
import CryptoKit
@testable import UmeroKit

@Suite("MD5 Format Tests")
struct MD5FormatTests {

    @Test("Hex format exactly matches")
    func hexFormatExactly() {
        // Test that the hex format is lowercase and padded correctly
        let testString = "test"

        // Manual byte-by-byte comparison
        let data = Data(testString.utf8)
        let digest = Insecure.MD5.hash(data: data)

        // Original format
        let originalFormat = digest.map { String(format: "%02hhx", $0) }.joined()

        // Our helper
        let helperFormat = MD5Helper.hash(testString)

        #expect(helperFormat == originalFormat)

        // Verify it's lowercase hex
        #expect(helperFormat == helperFormat.lowercased())

        // Verify length
        #expect(helperFormat.count == 32)

        // Known MD5 for "test"
        #expect(helperFormat == "098f6bcd4621d373cade4e832627b4f6")
    }

    @Test("Format with leading zeros")
    func formatWithLeadingZeros() {
        // Test edge case where bytes might need zero padding
        // Using a string that produces MD5 with leading zeros in some bytes
        let testString = "1" // MD5: c4ca4238a0b923820dcc509a6f75849b

        let hash = MD5Helper.hash(testString)

        // Verify no missing leading zeros
        #expect(hash.count == 32)
        #expect(hash == "c4ca4238a0b923820dcc509a6f75849b")

        // Check that format "%02hhx" is working correctly
        // The "a0" in position 8-9 shows zero padding is working
        let substring = String(hash[hash.index(hash.startIndex, offsetBy: 8)..<hash.index(hash.startIndex, offsetBy: 10)])
        #expect(substring == "a0")
    }

    @Test("Last.fm example signature")
    func lastFmExampleSignature() {
        // Using an example from Last.fm documentation (if available)
        // This is a mock example but follows their pattern
        let params = [
            "api_key": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            "method": "auth.getToken"
        ]
        let secret = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

        var signature = ""
        for key in params.keys.sorted() {
            signature += "\(key)\(params[key]!)"
        }
        signature += secret

        let hash1 = MD5Helper.hash(signature)

        // Double check with inline implementation
        let data = Data(signature.utf8)
        let hash2 = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

        #expect(hash1 == hash2)
    }
}