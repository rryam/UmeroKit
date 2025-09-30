import Foundation
import Testing
@testable import UmeroKit

@Suite("Decoding Resilience Tests")
struct DecodingResilienceTests {

    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    @Test
    func tagAllowsMissingReach() throws {
        guard #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }
        let decoder = makeDecoder()
        let data = """
        {
          "name": "rock",
          "count": 10,
          "total": 100
        }
        """.data(using: .utf8)!

        let tag = try decoder.decode(UTag.self, from: data)
        #expect(tag.reach == nil)
    }

    @Test
    func tagThrowsForInvalidReach() {
        guard #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }
        let decoder = makeDecoder()
        let data = """
        {
          "name": "jazz",
          "reach": "invalid"
        }
        """.data(using: .utf8)!

        #expect(throws: UmeroKitError.self) {
            _ = try decoder.decode(UTag.self, from: data)
        }
    }

    @Test
    func trackDefaultsMissingMetricsToZero() throws {
        guard #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }
        let decoder = makeDecoder()
        let data = """
        {
          "name": "Aerodynamic",
          "duration": "",
          "playcount": "1234",
          "listeners": "",
          "mbid": "",
          "url": "https://example.com/track",
          "image": [],
          "artist": {
            "name": "Daft Punk",
            "url": "https://example.com/artist",
            "mbid": "",
            "image": [],
            "streamable": "0"
          }
        }
        """.data(using: .utf8)!

        let track = try decoder.decode(UTrack.self, from: data)
        #expect(track.duration == 0)
        #expect(track.listeners == 0)
        #expect(track.playcount == 1234)
        #expect(track.mbid?.rawValue == "")
    }

    @Test
    func artistThrowsForInvalidPlaycount() {
        guard #available(macOS 11.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *) else { return }
        let decoder = makeDecoder()
        let data = """
        {
          "name": "Muse",
          "url": "https://example.com/artist",
          "playcount": "not-a-number"
        }
        """.data(using: .utf8)!

        #expect(throws: UmeroKitError.self) {
            _ = try decoder.decode(UArtist.self, from: data)
        }
    }
}
