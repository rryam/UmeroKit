//
//  UmeroKit.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation
import CryptoKit

// swiftlint:disable file_length

struct UItemCollection: Codable {
  let album: UAlbum
}

public struct UmeroKit: Sendable {
  private let apiKey: String
  private let secret: String
  private let username: String?
  private let password: String?

  public init(apiKey: String, secret: String, username: String? = nil, password: String? = nil) {
    self.apiKey = apiKey
    self.secret = secret
    self.username = username
    self.password = password
  }
}

extension UmeroKit {
  public func updateNowPlaying(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .updateNowPlaying,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func scrobble(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .scrobble,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func love(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = ULoveRequest(
      track: track,
      artist: artist,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func checkLogin(username: String, password: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    _ = try await authRequest.response()
  }
}

struct NowPlayingPostData: Codable {
  var method: String
  var track: String
  var artist: String
  var api_sig: String
  var api_key: String
  var sk: String
}

// MARK: - ALBUM
extension UmeroKit {
  public func albumInfo(for album: String,
                        artist: String,
                        autocorrect: Bool = false,
                        username: String? = nil,
                        language: String? = nil) async throws -> UAlbum {
    var components = UURLComponents(apiKey: apiKey, endpoint: AlbumEndpoint.getInfo)

    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "album", value: album),
      URLQueryItem(name: "artist", value: artist),
      URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)")
    ]

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    let request = UDataRequest<UItemCollection>(url: components.url)
    let response = try await request.response()
    return response.album
  }

  public func albumInfo(for mbid: UItemID,
                        autocorrect: Bool = false,
                        username: String? = nil,
                        language: String? = nil) async throws -> UAlbum {
    var components = UURLComponents(apiKey: apiKey, endpoint: AlbumEndpoint.getInfo)

    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "mbid", value: mbid.rawValue),
      URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)")
    ]

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    let request = UDataRequest<UItemCollection>(url: components.url)
    let response = try await request.response()
    return response.album
  }

  public func albumTopTags(for album: String,
                           artist: String,
                           autocorrect: Bool = false,
                           username: String? = nil,
                           language: String? = nil) async throws -> UTopTags {
    var components = UURLComponents(apiKey: apiKey, endpoint: AlbumEndpoint.getTopTags)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "album", value: album))
    queryItems.append(URLQueryItem(name: "artist", value: artist))
    queryItems.append(URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)"))

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    let request = UDataRequest<UTopTags>(url: components.url)
    let response = try await request.response()
    return response
  }

  /// Search for an album by name. Returns album matches sorted by relevance.
  /// - Parameters:
  ///   - album: The album name to search for.
  ///   - page: The page number to fetch (default: 1).
  ///   - limit: The number of results to fetch per page (default: 30, max: 100).
  /// - Returns: Search results containing matching albums and metadata.
  public func searchAlbum(album: String, page: Int = 1, limit: Int = 30) async throws -> UAlbumSearchResults {
    guard !album.isEmpty else { throw UmeroKitError.invalidURL }

    var components = UURLComponents(apiKey: apiKey, endpoint: AlbumEndpoint.search)
    components.items = [
      URLQueryItem(name: "album", value: album),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "limit", value: String(min(limit, 100)))
    ]

    let request = UDataRequest<UAlbumSearch>(url: components.url)
    let response = try await request.response()
    return response.results
  }

  /// Get the tags applied by an individual user to an album on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tags = try await umero.albumTags(for: "OK Computer", artist: "Radiohead", username: "rj")
  ///  } catch {
  ///    print("Error fetching album tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - album: The album name.
  ///   - artist: The artist name.
  ///   - username: The username whose tags you want to retrieve.
  /// - Returns: An array of `UTag` objects representing the tags.
  public func albumTags(
    for album: String,
    artist: String,
    username: String
  ) async throws -> [UTag] {
    var components = UURLComponents(apiKey: apiKey, endpoint: AlbumEndpoint.getTags)

    let queryItems: [URLQueryItem] = [
      URLQueryItem(name: "album", value: album),
      URLQueryItem(name: "artist", value: artist),
      URLQueryItem(name: "user", value: username)
    ]

    components.items = queryItems

    let request = UDataRequest<UAlbumTags>(url: components.url)
    let response = try await request.response()
    return response.tags.tag
  }
}

// MARK: - ARTIST
extension UmeroKit {
  public func artistInfo(for artist: String,
                         autocorrect: Bool = true,
                         username: String? = nil,
                         language: String? = nil) async throws -> UArtist {

    var components = UURLComponents(apiKey: apiKey, endpoint: ArtistEndpoint.getInfo)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "artist", value: artist))
    queryItems.append(URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)"))

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    let request = UDataRequest<UArtist>(url: components.url)
    let response = try await request.response()
    return response
  }

  /// Search for an artist by name. Returns artist matches sorted by relevance.
  /// - Parameters:
  ///   - artist: The artist name to search for.
  ///   - page: The page number to fetch (default: 1).
  ///   - limit: The number of results to fetch per page (default: 30, max: 50).
  /// - Returns: Search results containing matching artists and metadata.
  public func searchArtist(artist: String, page: Int = 1, limit: Int = 30) async throws -> UArtistSearchResults {
    guard !artist.isEmpty else { throw UmeroKitError.invalidURL }

    var components = UURLComponents(apiKey: apiKey, endpoint: ArtistEndpoint.search)
    components.items = [
      URLQueryItem(name: "artist", value: artist),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "limit", value: String(min(limit, 50)))
    ]

    let request = UDataRequest<UArtistSearch>(url: components.url)
    let response = try await request.response()
    return response.results
  }

  /// Helper function to fetch artist data from Last.fm API endpoints.
  ///
  /// - Parameters:
  ///   - endpoint: The artist endpoint to call.
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled artist names into correct artist names (optional).
  ///   - limit: The number of items to retrieve (optional).
  ///   - page: The page of results to retrieve (optional).
  ///   - username: The username for user-specific endpoints (optional).
  /// - Returns: The decoded response model of type `T`.
  private func getArtistData<T: Decodable>(
    _ endpoint: ArtistEndpoint,
    for artist: String,
    autocorrect: Bool? = nil,
    limit: Int? = nil,
    page: Int? = nil,
    username: String? = nil
  ) async throws -> T {
    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "artist", value: artist)
    ]

    if let autocorrect {
      queryItems.append(URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)"))
    }

    if let limit {
      queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
    }

    if let page {
      queryItems.append(URLQueryItem(name: "page", value: String(page)))
    }

    if let username {
      queryItems.append(URLQueryItem(name: "user", value: username))
    }

    components.items = queryItems

    let request = UDataRequest<T>(url: components.url)
    return try await request.response()
  }

  /// Get the top albums for an artist on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let albums = try await umero.artistTopAlbums(for: "Radiohead")
  ///  } catch {
  ///    print("Error fetching top albums: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled artist names into correct artist names (default: false).
  ///   - limit: The number of albums to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UArtistTopAlbums` object containing the top albums for the artist.
  public func artistTopAlbums(
    for artist: String,
    autocorrect: Bool = false,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UArtistTopAlbums {
    try await getArtistData(
      .getTopAlbums,
      for: artist,
      autocorrect: autocorrect,
      limit: limit,
      page: page
    )
  }

  /// Get the top tracks for an artist on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tracks = try await umero.artistTopTracks(for: "Radiohead")
  ///  } catch {
  ///    print("Error fetching top tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled artist names into correct artist names (default: false).
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UArtistTopTracks` object containing the top tracks for the artist.
  public func artistTopTracks(
    for artist: String,
    autocorrect: Bool = false,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UArtistTopTracks {
    try await getArtistData(
      .getTopTracks,
      for: artist,
      autocorrect: autocorrect,
      limit: limit,
      page: page
    )
  }

  /// Get similar artists to the specified artist on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let similarArtists = try await umero.similarArtists(for: "Radiohead")
  ///  } catch {
  ///    print("Error fetching similar artists: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled artist names into correct artist names (default: false).
  ///   - limit: The number of similar artists to retrieve (default: 50).
  /// - Returns: An array of `UArtist` objects representing similar artists.
  public func similarArtists(
    for artist: String,
    autocorrect: Bool = false,
    limit: Int = 50
  ) async throws -> [UArtist] {
    let response: UArtistSimilar = try await getArtistData(
      .getSimilar,
      for: artist,
      autocorrect: autocorrect,
      limit: limit
    )
    return response.artists
  }

  /// Get the tags applied by an individual user to an artist on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tags = try await umero.artistTags(for: "Radiohead", username: "rj")
  ///  } catch {
  ///    print("Error fetching artist tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - artist: The artist name.
  ///   - username: The username whose tags you want to retrieve.
  /// - Returns: An array of `UTag` objects representing the tags.
  public func artistTags(
    for artist: String,
    username: String
  ) async throws -> [UTag] {
    let response: UArtistTags = try await getArtistData(
      .getTags,
      for: artist,
      username: username
    )
    return response.tags.tag
  }

  /// Get the top tags for an artist on Last.fm, ordered by popularity.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tags = try await umero.artistTopTags(for: "Radiohead")
  ///  } catch {
  ///    print("Error fetching top tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled artist names into correct artist names (default: false).
  /// - Returns: A `UTopTags` object containing the top tags.
  public func artistTopTags(
    for artist: String,
    autocorrect: Bool = false
  ) async throws -> UTopTags {
    try await getArtistData(.getTopTags, for: artist, autocorrect: autocorrect)
  }
}

// MARK: - TAG
extension UmeroKit {
  public func tagInfo(for tag: String,
                      language: String? = nil) async throws -> UTag {
    var components = UURLComponents(apiKey: apiKey, endpoint: TagEndpoint.getInfo)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "tag", value: tag))

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    let request = UDataRequest<UTagInfo>(url: components.url)
    let response = try await request.response()
    return response.tag
  }

  public func topTags() async throws -> [UTag] {
    let components = UURLComponents(apiKey: apiKey, endpoint: TagEndpoint.getTopTags)
    let request = UDataRequest<UTopTags>(url: components.url)
    let response = try await request.response()
    return response.toptags.tag
  }

  /// Get the top artists for a tag on Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tagArtists = try await umero.tagTopArtists(for: "rock")
  ///  } catch {
  ///    print("Error fetching the top artists for tag: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - tag: The tag name.
  ///   - limit: The number of artists to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UTagTopArtists` object containing the top artists for the tag.
  public func tagTopArtists(for tag: String, limit: Int = 50, page: Int = 1) async throws -> UTagTopArtists {
    let request = UTagRequest<UTagTopArtists>(for: tag, endpoint: TagEndpoint.getTopArtists, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get the top albums for a tag on Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tagAlbums = try await umero.tagTopAlbums(for: "rock")
  ///  } catch {
  ///    print("Error fetching the top albums for tag: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - tag: The tag name.
  ///   - limit: The number of albums to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UTagTopAlbums` object containing the top albums for the tag.
  public func tagTopAlbums(for tag: String, limit: Int = 50, page: Int = 1) async throws -> UTagTopAlbums {
    let request = UTagRequest<UTagTopAlbums>(for: tag, endpoint: TagEndpoint.getTopAlbums, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get the top tracks for a tag on Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tagTracks = try await umero.tagTopTracks(for: "rock")
  ///  } catch {
  ///    print("Error fetching the top tracks for tag: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - tag: The tag name.
  ///   - limit: The number of tracks to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UTagTopTracks` object containing the top tracks for the tag.
  public func tagTopTracks(for tag: String, limit: Int = 50, page: Int = 1) async throws -> UTagTopTracks {
    let request = UTagRequest<UTagTopTracks>(for: tag, endpoint: TagEndpoint.getTopTracks, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get similar tags to the specified tag on Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let similarTags = try await umero.similarTags(for: "rock")
  ///  } catch {
  ///    print("Error fetching similar tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - tag: The tag name.
  /// - Returns: An array of `UTag` objects representing similar tags.
  public func similarTags(for tag: String) async throws -> [UTag] {
    let response: UTagSimilar = try await simpleTagRequest(for: tag, endpoint: .getSimilar)
    return response.tags
  }

  /// Get the weekly chart list for a tag on Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let chartList = try await umero.tagWeeklyChartList(for: "rock")
  ///  } catch {
  ///    print("Error fetching weekly chart list: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - tag: The tag name.
  /// - Returns: A `UTagWeeklyChartList` object containing the weekly chart list entries.
  public func tagWeeklyChartList(for tag: String) async throws -> UTagWeeklyChartList {
    return try await simpleTagRequest(for: tag, endpoint: .getWeeklyChartList)
  }

  private func simpleTagRequest<T: Decodable>(for tag: String, endpoint: TagEndpoint) async throws -> T {
    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    components.items = [URLQueryItem(name: "tag", value: tag)]
    let request = UDataRequest<T>(url: components.url)
    return try await request.response()
  }
}

// MARK: - CHARTS
extension UmeroKit {

  /// Get the top artists chart from Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let chartArtists = try await umero.topChartArtists()
  ///  } catch {
  ///    print("Error fetching the top chart artists: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - limit: The number of artists to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UChartArtists` object containing the top charting artists.
  public func topChartArtists(limit: Int = 50, page: Int = 1) async throws -> UChartArtists {
    let request = UChartRequest<UChartArtists>(for: .getTopArtists, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get the top tags chart from Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let chartArtists = try await umero.topChartTags()
  ///  } catch {
  ///    print("Error fetching the top chart tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - limit: The number of tags to retrieve (default is 50).
  ///   - page: The page number to retrieve (default is 1).
  /// - Returns: A `UChartTags` object containing the top charting tags.
  public func topChartTags(limit: Int = 50, page: Int = 1) async throws -> UChartTags {
    let request = UChartRequest<UChartTags>(for: .getTopTags, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get the top tracks chart from Last.fm
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let chartArtists = try await umero.topChartTracks()
  ///  } catch {
  ///    print("Error fetching the top chart tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - limit: The number of tracks to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UChartTracks` object containing the top charting tracks.
  public func topChartTracks(limit: Int = 50, page: Int = 1) async throws -> UChartTracks {
    let request = UChartRequest<UChartTracks>(for: .getTopTracks, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }
}

// MARK: - GEO
extension UmeroKit {

  /// Get the most popular artists on Last.fm by country
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let country = "India"
  ///    let chartArtists = try await umero.topArtists(for: country)
  ///  } catch {
  ///    print("Error fetching the most popular artists for \(country): \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - country: A country name, as defined by the ISO 3166-1 country names standard
  ///   - limit: The number of artists to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UGeoArtists` object containing the most popular artists.
  public func topArtists(for country: String, limit: Int = 50, page: Int = 1) async throws -> UGeoArtists {
    let request = UGeoRequest<UGeoArtists>(for: country, endpoint: .getTopArtists, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  /// Get the most popular tracks on Last.fm last week by country
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let country = "India"
  ///    let chartArtists = try await umero.topTracks(for: country)
  ///  } catch {
  ///    print("Error fetching the most popular tracks for \(country): \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - country: A country name, as defined by the ISO 3166-1 country names standard
  ///   - limit: The number of tracks to retrieve (default is 50).
  ///   - page: The page of results to retrieve (default is 1).
  /// - Returns: A `UGeoTracks` object containing the most popular tracks.
  public func topTracks(for country: String, limit: Int = 50, page: Int = 1) async throws -> UGeoTracks {
    let request = UGeoRequest<UGeoTracks>(for: country, endpoint: .getTopTracks, limit: limit, page: page)
    let response = try await request.response(with: apiKey)
    return response
  }

  // MARK: - TRACK
  /// Search for a track by name. Optionally narrow the search to a specific artist.
  /// - Parameters:
  ///   - track: The track name to search for.
  ///   - artist: Optionally narrow the search to tracks by this specific artist.
  ///   - page: The page number to fetch (default: 1).
  ///   - limit: The number of results to fetch per page (default: 30, max: 50).
  /// - Returns: Search results containing matching tracks and metadata.
  public func searchTrack(
    track: String,
    artist: String? = nil,
    page: Int = 1,
    limit: Int = 30
  ) async throws -> UTrackSearchResults {
    guard !track.isEmpty else { throw UmeroKitError.invalidURL }

    var components = UURLComponents(apiKey: apiKey, endpoint: TrackEndpoint.search)
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "track", value: track),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "limit", value: String(min(limit, 50)))
    ]

    if let artist = artist, !artist.isEmpty {
      queryItems.append(URLQueryItem(name: "artist", value: artist))
    }

    components.items = queryItems

    let request = UDataRequest<UTrackSearch>(url: components.url)
    let response = try await request.response()
    return response.results
  }

  /// Helper function to fetch track data from Last.fm API endpoints.
  ///
  /// - Parameters:
  ///   - endpoint: The track endpoint to call.
  ///   - track: The track name.
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled track names into correct track names (default: false).
  ///   - additionalItems: Additional query items to add (e.g., username, limit).
  /// - Returns: The decoded response model of type `T`.
  private func getTrackData<T: Codable>(
    _ endpoint: TrackEndpoint,
    for track: String,
    artist: String,
    autocorrect: Bool = false,
    additionalItems: [URLQueryItem] = []
  ) async throws -> T {
    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "track", value: track),
      URLQueryItem(name: "artist", value: artist),
      URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)")
    ]
    queryItems.append(contentsOf: additionalItems)
    
    components.items = queryItems
    
    let request = UDataRequest<T>(url: components.url)
    return try await request.response()
  }

  /// Get the metadata for a track on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let track = try await umero.trackInfo(for: "Bohemian Rhapsody", artist: "Queen")
  ///  } catch {
  ///    print("Error fetching track info: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - track: The track name.
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled track names into correct track names (default: false).
  ///   - username: Username whose context to get the track info in (optional).
  /// - Returns: A `UTrack` object containing the track metadata.
  public func trackInfo(
    for track: String,
    artist: String,
    autocorrect: Bool = false,
    username: String? = nil
  ) async throws -> UTrack {
    var additionalItems: [URLQueryItem] = []
    if let username {
      additionalItems.append(URLQueryItem(name: "username", value: username))
    }
    
    let response: UTrackInfo = try await getTrackData(
      .getInfo,
      for: track,
      artist: artist,
      autocorrect: autocorrect,
      additionalItems: additionalItems
    )
    return response.track
  }

  /// Get the tags applied by an individual user to a track on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tags = try await umero.trackTags(for: "Bohemian Rhapsody", artist: "Queen", username: "rj")
  ///  } catch {
  ///    print("Error fetching track tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - track: The track name.
  ///   - artist: The artist name.
  ///   - username: The username whose tags you want to retrieve.
  /// - Returns: An array of `UTag` objects representing the tags.
  public func trackTags(
    for track: String,
    artist: String,
    username: String
  ) async throws -> [UTag] {
    let response: UTrackTags = try await getTrackData(
      .getTags,
      for: track,
      artist: artist,
      additionalItems: [URLQueryItem(name: "user", value: username)]
    )
    return response.tags.tag
  }

  /// Get the top tags for a track on Last.fm, ordered by popularity.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let tags = try await umero.trackTopTags(for: "Bohemian Rhapsody", artist: "Queen")
  ///  } catch {
  ///    print("Error fetching top tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - track: The track name.
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled track names into correct track names (default: false).
  /// - Returns: A `UTopTags` object containing the top tags.
  public func trackTopTags(
    for track: String,
    artist: String,
    autocorrect: Bool = false
  ) async throws -> UTopTags {
    try await getTrackData(.getTopTags, for: track, artist: artist, autocorrect: autocorrect)
  }

  /// Get similar tracks to the specified track on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey)
  ///    let similarTracks = try await umero.similarTracks(for: "Bohemian Rhapsody", artist: "Queen")
  ///  } catch {
  ///    print("Error fetching similar tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - track: The track name.
  ///   - artist: The artist name.
  ///   - autocorrect: Transform misspelled track names into correct track names (default: false).
  ///   - limit: The number of similar tracks to retrieve (default: 50).
  /// - Returns: An array of `UTrack` objects representing similar tracks.
  public func similarTracks(
    for track: String,
    artist: String,
    autocorrect: Bool = false,
    limit: Int = 50
  ) async throws -> [UTrack] {
    let response: UTrackSimilar = try await getTrackData(
      .getSimilar,
      for: track,
      artist: artist,
      autocorrect: autocorrect,
      additionalItems: [URLQueryItem(name: "limit", value: String(limit))]
    )
    return response.tracks
  }
}

// MARK: - USER
extension UmeroKit {
  /// Helper function to fetch user data from Last.fm API endpoints.
  ///
  /// - Parameters:
  ///   - endpoint: The user endpoint to call.
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of items to retrieve (optional).
  ///   - page: The page of results to retrieve (optional).
  ///   - period: The time period for top items (optional).
  ///   - from: The start date/timestamp (optional).
  ///   - to: The end date/timestamp (optional).
  ///   - extended: Whether to return extended information (optional).
  ///   - taggingtype: The type of tags to retrieve (optional).
  /// - Returns: The decoded response model of type `T`.
  private func getUserData<T: Decodable>(
    _ endpoint: UserEndpoint,
    username: String? = nil,
    limit: Int? = nil,
    page: Int? = nil,
    period: String? = nil,
    from: Int? = nil,
    to: Int? = nil,
    extended: Bool? = nil,
    taggingtype: String? = nil
  ) async throws -> T {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let instanceUsername = self.username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    // Authenticate to get session key
    let authRequest = UAuthDataRequest(
      username: instanceUsername,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "sk", value: authResponse.key)
    ]

    // Add username parameter if provided (for querying other users)
    // If not provided, use the authenticated user's username
    let targetUsername = username ?? instanceUsername
    queryItems.append(URLQueryItem(name: "user", value: targetUsername))

    // Helper function to conditionally add query items
    func addQueryItemIfPresent(_ name: String, value: String?) {
      if let value {
        queryItems.append(URLQueryItem(name: name, value: value))
      }
    }

    addQueryItemIfPresent("limit", value: limit.map { String($0) })
    addQueryItemIfPresent("page", value: page.map { String($0) })
    addQueryItemIfPresent("period", value: period)
    addQueryItemIfPresent("from", value: from.map { String($0) })
    addQueryItemIfPresent("to", value: to.map { String($0) })
    
    if let extended {
      queryItems.append(URLQueryItem(name: "extended", value: "\(extended.intValue)"))
    }
    
    addQueryItemIfPresent("taggingtype", value: taggingtype)

    components.items = queryItems

    let request = UDataRequest<T>(url: components.url)
    return try await request.response()
  }

  /// Get user profile information.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let userInfo = try await umero.userInfo()
  ///  } catch {
  ///    print("Error fetching user info: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username to get info for (optional, defaults to authenticated user).
  /// - Returns: A `UUserInfo` object containing the user's profile information.
  public func userInfo(for username: String? = nil) async throws -> UUserInfo {
    try await getUserData(.getInfo, username: username)
  }

  /// Get tags applied by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userTags(for: "someuser")
  ///  } catch {
  ///    print("Error fetching user tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username whose tags you want to retrieve (optional, defaults to authenticated user).
  /// - Returns: An array of `UTag` objects representing the tags.
  public func userTags(for username: String? = nil) async throws -> [UTag] {
    let response: UUserTags = try await getUserData(.getTags, username: username)
    return response.tags.tag
  }

  /// Get the top tags for a user on Last.fm, ordered by popularity.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userTopTags(for: "someuser")
  ///  } catch {
  ///    print("Error fetching top tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tags to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopTags` object containing the top tags.
  public func userTopTags(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopTags {
    try await getUserData(.getTopTags, username: username, limit: limit, page: page)
  }

  /// Get the top artists for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let artists = try await umero.userTopArtists(for: "someuser", period: "overall")
  ///  } catch {
  ///    print("Error fetching top artists: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of artists to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopArtists` object containing the top artists for the user.
  public func userTopArtists(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopArtists {
    try await getUserData(.getTopArtists, username: username, limit: limit, page: page, period: period)
  }

  /// Get the top albums for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let albums = try await umero.userTopAlbums(for: "someuser", period: "7day")
  ///  } catch {
  ///    print("Error fetching top albums: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of albums to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopAlbums` object containing the top albums for the user.
  public func userTopAlbums(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopAlbums {
    try await getUserData(.getTopAlbums, username: username, limit: limit, page: page, period: period)
  }

  /// Get the top tracks for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userTopTracks(for: "someuser", period: "1month")
  ///  } catch {
  ///    print("Error fetching top tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopTracks` object containing the top tracks for the user.
  public func userTopTracks(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopTracks {
    try await getUserData(.getTopTracks, username: username, limit: limit, page: page, period: period)
  }

  /// Get recent tracks scrobbled by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userRecentTracks(for: "someuser", limit: 10)
  ///  } catch {
  ///    print("Error fetching recent tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  ///   - from: The start timestamp (optional).
  ///   - to: The end timestamp (optional).
  ///   - extended: Whether to return extended information (default: false).
  /// - Returns: A `UUserRecentTracks` object containing the recent tracks.
  public func userRecentTracks(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1,
    from: Int? = nil,
    to: Int? = nil,
    extended: Bool = false
  ) async throws -> UUserRecentTracks {
    try await getUserData(
      .getRecentTracks,
      username: username,
      limit: limit,
      page: page,
      from: from,
      to: to,
      extended: extended
    )
  }

  /// Get loved tracks by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userLovedTracks(for: "someuser")
  ///  } catch {
  ///    print("Error fetching loved tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserLovedTracks` object containing the loved tracks.
  public func userLovedTracks(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserLovedTracks {
    try await getUserData(.getLovedTracks, username: username, limit: limit, page: page)
  }

  /// Get the list of available weekly charts for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chartList = try await umero.userWeeklyChartList(for: "someuser")
  ///  } catch {
  ///    print("Error fetching weekly chart list: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username (optional, defaults to authenticated user).
  /// - Returns: A `UUserWeeklyChartList` object containing the list of available weekly charts.
  public func userWeeklyChartList(for username: String? = nil) async throws -> UUserWeeklyChartList {
    try await getUserData(.getWeeklyChartList, username: username)
  }

  /// Get a weekly album chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyAlbumChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly album chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyAlbumChart` object containing the weekly album chart.
  public func userWeeklyAlbumChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyAlbumChart {
    try await getUserData(.getWeeklyAlbumChart, username: username, from: from, to: to)
  }

  /// Get a weekly artist chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyArtistChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly artist chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyArtistChart` object containing the weekly artist chart.
  public func userWeeklyArtistChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyArtistChart {
    try await getUserData(.getWeeklyArtistChart, username: username, from: from, to: to)
  }

  /// Get a weekly track chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyTrackChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly track chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyTrackChart` object containing the weekly track chart.
  public func userWeeklyTrackChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyTrackChart {
    try await getUserData(.getWeeklyTrackChart, username: username, from: from, to: to)
  }

  /// Get a user's friends.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let friends = try await umero.userFriends(for: "someuser")
  ///  } catch {
  ///    print("Error fetching friends: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of friends to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserFriends` object containing the user's friends.
  public func userFriends(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserFriends {
    try await getUserData(.getFriends, username: username, limit: limit, page: page)
  }

  /// Get personal tags applied by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userPersonalTags(for: "someuser", taggingtype: "artist")
  ///  } catch {
  ///    print("Error fetching personal tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - taggingtype: The type of tags to retrieve (artist, album, or track).
  ///   - limit: The number of tags to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserPersonalTags` object containing the personal tags.
  public func userPersonalTags(
    for username: String? = nil,
    taggingtype: String,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserPersonalTags {
    try await getUserData(.getPersonalTags, username: username, limit: limit, page: page, taggingtype: taggingtype)
  }
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
