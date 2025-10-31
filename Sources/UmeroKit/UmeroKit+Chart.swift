//
//  UmeroKit+Chart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Chart
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
