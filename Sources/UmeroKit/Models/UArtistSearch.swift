//
//  UArtistSearch.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the response structure for artist search results from Last.fm API.
public struct UArtistSearch {
  /// The search results containing matching artists and metadata.
  public let results: UArtistSearchResults
}

extension UArtistSearch {
  enum MainKey: String, CodingKey {
    case results
  }
}

extension UArtistSearch: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    self.results = try container.decode(UArtistSearchResults.self, forKey: .results)
  }
}

extension UArtistSearch: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    try container.encode(results, forKey: .results)
  }
}

/// Represents the search results for artists with matches and attributes.
public struct UArtistSearchResults {
  /// Collection of artist matches found in the search.
  public let artists: UArtistSearchMatches

  /// Search metadata including pagination information.
  public let attributes: USearchAttributes
}

extension UArtistSearchResults {
  enum CodingKeys: String, CodingKey {
    case artistmatches = "artistmatches"
    case attributes = "opensearch:Query"
  }
}

extension UArtistSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.artists = try container.decode(UArtistSearchMatches.self, forKey: .artistmatches)

    // The attributes are usually nested in the "opensearch:Query" field
    if let queryAttributes = try? container.decodeIfPresent(USearchAttributes.self, forKey: .attributes) {
      self.attributes = queryAttributes
    } else {
      // If opensearch:Query doesn't exist, create a default attributes object
      // This might need to be adjusted based on actual API response structure
      self.attributes = USearchAttributes(
        page: 1,
        totalPages: 1,
        totalResults: artists.artist.count,
        itemsPerPage: artists.artist.count
      )
    }
  }
}

extension UArtistSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(artists, forKey: .artistmatches)
    try container.encode(attributes, forKey: .attributes)
  }
}

/// Represents the collection of artist matches from a search.
public struct UArtistSearchMatches {
  /// Array of artists that match the search query.
  public let artist: [UArtist]
}

extension UArtistSearchMatches: Decodable {}
extension UArtistSearchMatches: Encodable {}
