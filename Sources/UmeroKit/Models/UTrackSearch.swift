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

private struct QueryInfo: Codable {
  let startPage: String

  enum CodingKeys: String, CodingKey {
    case startPage
  }
}

extension UTrackSearchResults {
  enum CodingKeys: String, CodingKey {
    case trackmatches = "trackmatches"
    case query = "opensearch:Query"
    case totalResults = "opensearch:totalResults"
    case itemsPerPage = "opensearch:itemsPerPage"
  }
}

extension UTrackSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.tracks = try container.decode(UTrackSearchMatches.self, forKey: .trackmatches)

    // Parse pagination metadata from opensearch fields
    let queryInfo = try container.decode(QueryInfo.self, forKey: .query)
    let totalResultsString = try container.decode(String.self, forKey: .totalResults)
    let itemsPerPageString = try container.decode(String.self, forKey: .itemsPerPage)

    let startPage = Int(queryInfo.startPage) ?? 1
    let totalResults = Int(totalResultsString) ?? 0
    let itemsPerPage = Int(itemsPerPageString) ?? 30

    // Calculate total pages
    let totalPages = itemsPerPage > 0 ? (totalResults + itemsPerPage - 1) / itemsPerPage : 0

    self.attributes = USearchAttributes(
      page: startPage,
      totalPages: totalPages,
      totalResults: totalResults,
      itemsPerPage: itemsPerPage
    )
  }
}

extension UTrackSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(tracks, forKey: .trackmatches)

    let queryInfo = QueryInfo(startPage: String(attributes.page))
    try container.encode(queryInfo, forKey: .query)
    try container.encode(String(attributes.totalResults), forKey: .totalResults)
    try container.encode(String(attributes.itemsPerPage), forKey: .itemsPerPage)
  }
}

/// Represents the collection of track matches from a search.
public struct UTrackSearchMatches {
  /// Array of tracks that match the search query.
  public let track: [UTrackSearchResult]
}

extension UTrackSearchMatches: Decodable {}
extension UTrackSearchMatches: Encodable {}
