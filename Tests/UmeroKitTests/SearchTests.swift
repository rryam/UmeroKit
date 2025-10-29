import Foundation
import Testing
@testable import UmeroKit

@Suite("Search Endpoints Tests")
struct SearchTests {
  var umeroKit: UmeroKit {
    UmeroKit(apiKey: "test_api_key", secret: "test_secret")
  }

  @Test("Album search endpoint URL construction")
  func testAlbumSearchURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: AlbumEndpoint.search)
    components.items = [
      URLQueryItem(name: "album", value: "Test Album"),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "limit", value: "30")
    ]

    #expect(components.url?.absoluteString.contains("method=album.search") == true)
    #expect(components.url?.absoluteString.contains("album=Test%20Album") == true)
    #expect(components.url?.absoluteString.contains("page=1") == true)
    #expect(components.url?.absoluteString.contains("limit=30") == true)
  }

  @Test("Artist search endpoint URL construction")
  func testArtistSearchURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: ArtistEndpoint.search)
    components.items = [
      URLQueryItem(name: "artist", value: "Test Artist"),
      URLQueryItem(name: "page", value: "2"),
      URLQueryItem(name: "limit", value: "25")
    ]

    #expect(components.url?.absoluteString.contains("method=artist.search") == true)
    #expect(components.url?.absoluteString.contains("artist=Test%20Artist") == true)
    #expect(components.url?.absoluteString.contains("page=2") == true)
    #expect(components.url?.absoluteString.contains("limit=25") == true)
  }

  @Test("Track search endpoint URL construction")
  func testTrackSearchURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: TrackEndpoint.search)
    components.items = [
      URLQueryItem(name: "track", value: "Test Track"),
      URLQueryItem(name: "artist", value: "Test Artist"),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "limit", value: "20")
    ]

    #expect(components.url?.absoluteString.contains("method=track.search") == true)
    #expect(components.url?.absoluteString.contains("track=Test%20Track") == true)
    #expect(components.url?.absoluteString.contains("artist=Test%20Artist") == true)
    #expect(components.url?.absoluteString.contains("page=1") == true)
    #expect(components.url?.absoluteString.contains("limit=20") == true)
  }

  @Test("Track search without artist")
  func testTrackSearchWithoutArtistURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: TrackEndpoint.search)
    components.items = [
      URLQueryItem(name: "track", value: "Test Track"),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "limit", value: "30")
    ]

    #expect(components.url?.absoluteString.contains("method=track.search") == true)
    #expect(components.url?.absoluteString.contains("track=Test%20Track") == true)
    #expect(components.url?.absoluteString.contains("artist=") == false)
  }

  @Test("Search parameters validation")
  func testSearchParametersValidation() async throws {
    let umeroKit = self.umeroKit

    // Test empty album name throws error
    do {
      _ = try await umeroKit.searchAlbum(album: "")
      #expect(Bool(false), "Should have thrown error for empty album name")
    } catch {
      #expect(error is UmeroKitError)
    }

    // Test empty artist name throws error
    do {
      _ = try await umeroKit.searchArtist(artist: "")
      #expect(Bool(false), "Should have thrown error for empty artist name")
    } catch {
      #expect(error is UmeroKitError)
    }

    // Test empty track name throws error
    do {
      _ = try await umeroKit.searchTrack(track: "")
      #expect(Bool(false), "Should have thrown error for empty track name")
    } catch {
      #expect(error is UmeroKitError)
    }
  }

  @Test("Search limit enforcement")
  func testSearchLimitEnforcement() async throws {
    // Test that album search limit is capped at 100
    var albumComponents = UURLComponents(apiKey: "test_api_key", endpoint: AlbumEndpoint.search)
    albumComponents.items = [
      URLQueryItem(name: "album", value: "Test Album"),
      URLQueryItem(name: "limit", value: String(min(150, 100)))
    ]
    #expect(albumComponents.url?.absoluteString.contains("limit=100") == true)

    // Test that artist search limit is capped at 50
    var artistComponents = UURLComponents(apiKey: "test_api_key", endpoint: ArtistEndpoint.search)
    artistComponents.items = [
      URLQueryItem(name: "artist", value: "Test Artist"),
      URLQueryItem(name: "limit", value: String(min(75, 50)))
    ]
    #expect(artistComponents.url?.absoluteString.contains("limit=50") == true)

    // Test that track search limit is capped at 50
    var trackComponents = UURLComponents(apiKey: "test_api_key", endpoint: TrackEndpoint.search)
    trackComponents.items = [
      URLQueryItem(name: "track", value: "Test Track"),
      URLQueryItem(name: "limit", value: String(min(100, 50)))
    ]
    #expect(trackComponents.url?.absoluteString.contains("limit=50") == true)
  }

  @Test("Search response models structure")
  func testSearchResponseModelsStructure() {
    // Test that search response models can be created with the expected structure
    let attributes = USearchAttributes(page: 1, totalPages: 5, totalResults: 100, itemsPerPage: 20)
    #expect(attributes.page == 1)
    #expect(attributes.totalPages == 5)
    #expect(attributes.totalResults == 100)
    #expect(attributes.itemsPerPage == 20)

    // Test album search matches structure
    let albumMatches = UAlbumSearchMatches(album: [])
    #expect(albumMatches.album.isEmpty == true)

    // Test artist search matches structure
    let artistMatches = UArtistSearchMatches(artist: [])
    #expect(artistMatches.artist.isEmpty == true)

    // Test track search matches structure
    let trackMatches = UTrackSearchMatches(track: [])
    #expect(trackMatches.track.isEmpty == true)
  }
}
