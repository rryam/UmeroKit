//
//  UmeroKit.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation
import CryptoKit

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
    let request = UTagRequest<UTagTopArtists>(for: tag, endpoint: .getTopArtists, limit: limit, page: page)
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
    let request = UTagRequest<UTagTopAlbums>(for: tag, endpoint: .getTopAlbums, limit: limit, page: page)
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
    let request = UTagRequest<UTagTopTracks>(for: tag, endpoint: .getTopTracks, limit: limit, page: page)
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
    var components = UURLComponents(apiKey: apiKey, endpoint: TagEndpoint.getSimilar)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "tag", value: tag))

    components.items = queryItems

    let request = UDataRequest<UTagSimilar>(url: components.url)
    let response = try await request.response()
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
    var components = UURLComponents(apiKey: apiKey, endpoint: TagEndpoint.getWeeklyChartList)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "tag", value: tag))

    components.items = queryItems

    let request = UDataRequest<UTagWeeklyChartList>(url: components.url)
    let response = try await request.response()
    return response
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
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
