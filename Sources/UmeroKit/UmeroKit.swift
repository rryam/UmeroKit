//
//  UmeroKit.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

struct UItemCollection: Codable {
  let album: UAlbum
}

public let Umero = UmeroKit.default

public class UmeroKit {
  private static var apiKey: String = ""
  private static var secret: String = ""

  private static var username: String = ""
  private static var password: String = ""

  public static var `default`: UmeroKit {
    guard apiKey != "" else {
      fatalError("Provide the API Key.")
    }

    guard secret != "" else {
      fatalError("Provide the Shared Secret.")
    }

    return UmeroKit()
  }

  public static func configure(withAPIKey apiKey: String, sharedSecret: String) {
    Self.apiKey = apiKey
    Self.secret = sharedSecret
  }

  public static func configureUser(username: String, password: String) {
    Self.username = username
    Self.password = password
  }
}

extension UmeroKit {
  public func updateNowPlaying(track: String, artist: String) async throws {
    guard Self.username != "" else {
      throw NSError(domain: "Provide the username.", code: 0)
    }

    guard Self.password != "" else {
      throw NSError(domain: "Provide the password.", code: 0)
    }

    let authRequest = UAuthDataRequest(username: Self.username, password: Self.password, apiKey: Self.apiKey, secret: Self.secret)
    let authResponse = try await authRequest.response()

    let request = UScrobblingRequest(track: track, artist: artist, endpoint: .updateNowPlaying, apiKey: Self.apiKey, sessionKey: authResponse.key, secret: Self.secret)
    let response = try await request.response()
  }

  public func scrobble(track: String, artist: String) async throws {
    guard Self.username != "" else {
      throw NSError(domain: "Provide the username.", code: 0)
    }

    guard Self.password != "" else {
      throw NSError(domain: "Provide the password.", code: 0)
    }

    let authRequest = UAuthDataRequest(username: Self.username, password: Self.password, apiKey: Self.apiKey, secret: Self.secret)
    let authResponse = try await authRequest.response()
    let request = UScrobblingRequest(track: track, artist: artist, endpoint: .scrobble, apiKey: Self.apiKey, sessionKey: authResponse.key, secret: Self.secret)
    let response = try await request.response()
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
    var components = UURLComponents(apiKey: Self.apiKey, endpoint: AlbumEndpoint.getInfo)
    components.items = [URLQueryItem(name: "album", value: album), URLQueryItem(name: "artist", value: artist)]

    let request = UDataRequest<UItemCollection>(url: components.url)
    let response = try await request.response()
    return response.album
  }

  public func albumInfo(for mbid: UItemID,
                        autocorrect: Bool = false,
                        username: String? = nil,
                        language: String? = nil) async throws -> UAlbum {
    var components = UURLComponents(apiKey: Self.apiKey, endpoint: AlbumEndpoint.getInfo)
    components.items = [URLQueryItem(name: "mbid", value: mbid.rawValue)]

    let request = UDataRequest<UItemCollection>(url: components.url)
    let response = try await request.response()
    return response.album
  }

  public func albumTopTags(for album: String,
                           artist: String,
                           autocorrect: Bool = false,
                           username: String? = nil,
                           language: String? = nil) async throws -> UTopTags {
    var components = UURLComponents(apiKey: Self.apiKey, endpoint: AlbumEndpoint.getTopTags)

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
}

// MARK: - ARTIST
extension UmeroKit {
  public func artistInfo(for artist: String,
                         autocorrect: Bool = true,
                         username: String? = nil,
                         language: String? = nil) async throws -> UArtist {

    var components = UURLComponents(apiKey: Self.apiKey, endpoint: ArtistEndpoint.getInfo)

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
}

// MARK: - TAG
extension UmeroKit {
  public func tagInfo(for tag: String,
                      language: String? = nil) async throws -> UTag {
    var components = UURLComponents(apiKey: Self.apiKey, endpoint: TagEndpoint.getInfo)

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
    let components = UURLComponents(apiKey: Self.apiKey, endpoint: TagEndpoint.getTopTags)
    let request = UDataRequest<UTopTags>(url: components.url)
    let response = try await request.response()
    return response.toptags.tag
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
    let response = try await request.response(with: Self.apiKey)
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
    let response = try await request.response(with: Self.apiKey)
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
    let response = try await request.response(with: Self.apiKey)
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
    let response = try await request.response(with: Self.apiKey)
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
    let response = try await request.response(with: Self.apiKey)
    return response
  }
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
