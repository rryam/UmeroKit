//
//  UTrackSearch.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the response structure for track search results from Last.fm API.
public struct UTrackSearch {
  /// The search results containing matching tracks and metadata.
  public let results: UTrackSearchResults
}

extension UTrackSearch {
  enum MainKey: String, CodingKey {
    case results
  }
}

extension UTrackSearch: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    self.results = try container.decode(UTrackSearchResults.self, forKey: .results)
  }
}

extension UTrackSearch: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    try container.encode(results, forKey: .results)
  }
}

/// Represents the search results for tracks with matches and attributes.
public struct UTrackSearchResults {
  /// Collection of track matches found in the search.
  public let tracks: UTrackSearchMatches

  /// Search metadata including pagination information.
  public let attributes: USearchAttributes
}

extension UTrackSearchResults {
  enum CodingKeys: String, CodingKey {
    case trackmatches = "trackmatches"
    case attributes = "opensearch:Query"
  }
}

extension UTrackSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.tracks = try container.decode(UTrackSearchMatches.self, forKey: .trackmatches)

    // The attributes are usually nested in the "opensearch:Query" field
    if let queryAttributes = try? container.decodeIfPresent(USearchAttributes.self, forKey: .attributes) {
      self.attributes = queryAttributes
    } else {
      // If opensearch:Query doesn't exist, create reasonable defaults based on response content
      let itemCount = tracks.track.count
      self.attributes = USearchAttributes(
        page: 1,
        totalPages: itemCount > 0 ? 1 : 0,
        totalResults: itemCount,
        itemsPerPage: itemCount > 0 ? itemCount : 30
      )
    }
  }
}

extension UTrackSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(tracks, forKey: .trackmatches)
    try container.encode(attributes, forKey: .attributes)
  }
}

/// Represents the collection of track matches from a search.
public struct UTrackSearchMatches {
  /// Array of tracks that match the search query.
  public let track: [UTrack]
}

extension UTrackSearchMatches: Decodable {}
extension UTrackSearchMatches: Encodable {}
