//
//  UmeroKit+Tag.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Tag
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
