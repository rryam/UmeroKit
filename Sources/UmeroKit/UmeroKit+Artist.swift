//
//  UmeroKit+Artist.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Artist
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
