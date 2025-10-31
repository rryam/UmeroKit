//
//  UmeroKit+Geo.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Geo
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
}
