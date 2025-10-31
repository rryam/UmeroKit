//
//  UmeroKit+Track.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Track
extension UmeroKit {
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
