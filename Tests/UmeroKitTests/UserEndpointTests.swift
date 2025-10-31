import Foundation
import Testing
@testable import UmeroKit

@Suite("User Endpoints Tests")
struct UserEndpointTests {
  var umeroKit: UmeroKit {
    UmeroKit(apiKey: "test_api_key", secret: "test_secret", username: "testuser", password: "testpass")
  }

  @Test("User info endpoint URL construction")
  func testUserInfoURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getInfo)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getinfo") == true)
    #expect(components.url?.absoluteString.contains("user=testuser") == true)
    #expect(components.url?.absoluteString.contains("api_key=test_api_key") == true)
  }

  @Test("User recent tracks endpoint URL construction")
  func testUserRecentTracksURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getRecentTracks)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "limit", value: "10"),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "extended", value: "1")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getrecenttracks") == true)
    #expect(components.url?.absoluteString.contains("user=testuser") == true)
    #expect(components.url?.absoluteString.contains("limit=10") == true)
    #expect(components.url?.absoluteString.contains("extended=1") == true)
  }

  @Test("User top artists endpoint URL construction")
  func testUserTopArtistsURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getTopArtists)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "period", value: "7day"),
      URLQueryItem(name: "limit", value: "50"),
      URLQueryItem(name: "page", value: "1")
    ]

    #expect(components.url?.absoluteString.contains("method=user.gettopartists") == true)
    #expect(components.url?.absoluteString.contains("period=7day") == true)
    #expect(components.url?.absoluteString.contains("limit=50") == true)
  }

  @Test("User top albums endpoint URL construction")
  func testUserTopAlbumsURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getTopAlbums)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "period", value: "1month"),
      URLQueryItem(name: "limit", value: "50")
    ]

    #expect(components.url?.absoluteString.contains("method=user.gettopalbums") == true)
    #expect(components.url?.absoluteString.contains("period=1month") == true)
  }

  @Test("User top tracks endpoint URL construction")
  func testUserTopTracksURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getTopTracks)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "period", value: "12month"),
      URLQueryItem(name: "limit", value: "50")
    ]

    #expect(components.url?.absoluteString.contains("method=user.gettoptracks") == true)
    #expect(components.url?.absoluteString.contains("period=12month") == true)
  }

  @Test("User loved tracks endpoint URL construction")
  func testUserLovedTracksURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getLovedTracks)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "limit", value: "50"),
      URLQueryItem(name: "page", value: "1")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getlovedtracks") == true)
    #expect(components.url?.absoluteString.contains("limit=50") == true)
  }

  @Test("User weekly chart list endpoint URL construction")
  func testUserWeeklyChartListURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getWeeklyChartList)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getweeklychartlist") == true)
  }

  @Test("User weekly album chart endpoint URL construction")
  func testUserWeeklyAlbumChartURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getWeeklyAlbumChart)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "from", value: "1234567890"),
      URLQueryItem(name: "to", value: "1234567891")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getweeklyalbumchart") == true)
    #expect(components.url?.absoluteString.contains("from=1234567890") == true)
    #expect(components.url?.absoluteString.contains("to=1234567891") == true)
  }

  @Test("User personal tags endpoint URL construction")
  func testUserPersonalTagsURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getPersonalTags)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "tag", value: "rock"),
      URLQueryItem(name: "taggingtype", value: "artist"),
      URLQueryItem(name: "limit", value: "50")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getpersonaltags") == true)
    #expect(components.url?.absoluteString.contains("tag=rock") == true)
    #expect(components.url?.absoluteString.contains("taggingtype=artist") == true)
  }

  @Test("User friends endpoint URL construction")
  func testUserFriendsURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getFriends)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "limit", value: "50"),
      URLQueryItem(name: "page", value: "1")
    ]

    #expect(components.url?.absoluteString.contains("method=user.getfriends") == true)
    #expect(components.url?.absoluteString.contains("limit=50") == true)
  }

  @Test("User tags endpoint URL construction")
  func testUserTagsURL() throws {
    var components = UURLComponents(apiKey: "test_api_key", endpoint: UserEndpoint.getTags)
    components.items = [
      URLQueryItem(name: "sk", value: "test_session_key"),
      URLQueryItem(name: "user", value: "testuser"),
      URLQueryItem(name: "artist", value: "Test Artist")
    ]

    #expect(components.url?.absoluteString.contains("method=user.gettags") == true)
    #expect(components.url?.absoluteString.contains("artist=Test%20Artist") == true)
  }

  @Test("User response models structure")
  func testUserResponseModelsStructure() {
    // Test UUserRecentTracksAttributes
    let attributes = UUserRecentTracksAttributes(
      user: "testuser",
      page: 1,
      perPage: 50,
      totalPages: 10,
      total: 500
    )
    #expect(attributes.user == "testuser")
    #expect(attributes.page == 1)
    #expect(attributes.perPage == 50)
    #expect(attributes.totalPages == 10)
    #expect(attributes.total == 500)

    // Test URecentTrackArtist with actual API format (#text for name)
    let artistJSON = """
    {
      "mbid": "4fa5eab2-270a-44e9-bc84-cf9f00766c75",
      "#text": "Mario Vazquez"
    }
    """.data(using: .utf8)!
    
    do {
      let artist = try JSONDecoder().decode(URecentTrackArtist.self, from: artistJSON)
      #expect(artist.name == "Mario Vazquez")
      #expect(artist.mbid?.rawValue == "4fa5eab2-270a-44e9-bc84-cf9f00766c75")
    } catch {
      #expect(Bool(false), "Failed to decode URecentTrackArtist: \(error)")
    }
    
    // Test URecentTrackArtist without mbid
    let artistNoMbidJSON = """
    {
      "#text": "Test Artist"
    }
    """.data(using: .utf8)!
    
    do {
      let artistNoMbid = try JSONDecoder().decode(URecentTrackArtist.self, from: artistNoMbidJSON)
      #expect(artistNoMbid.name == "Test Artist")
      #expect(artistNoMbid.mbid == nil)
    } catch {
      #expect(Bool(false), "Failed to decode URecentTrackArtist without mbid: \(error)")
    }
  }

  @Test("User endpoint authentication requirements")
  func testUserEndpointAuthenticationRequirements() async throws {
    let umeroKitWithoutAuth = UmeroKit(apiKey: "test_api_key", secret: "test_secret")
    
    // All user endpoints require authentication
    do {
      _ = try await umeroKitWithoutAuth.userInfo(for: "testuser")
      #expect(Bool(false), "Should have thrown error for missing username")
    } catch {
      #expect(error is UmeroKitError)
    }
  }

}
