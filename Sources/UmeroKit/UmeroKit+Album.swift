//
//  UmeroKit+Album.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Album
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
