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

private struct QueryInfo: Codable {
  let startPage: String

  enum CodingKeys: String, CodingKey {
    case startPage
  }
}

extension UArtistSearchResults {
  enum CodingKeys: String, CodingKey {
    case artistmatches = "artistmatches"
    case query = "opensearch:Query"
    case totalResults = "opensearch:totalResults"
    case itemsPerPage = "opensearch:itemsPerPage"
  }
}

extension UArtistSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.artists = try container.decode(UArtistSearchMatches.self, forKey: .artistmatches)

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

extension UArtistSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(artists, forKey: .artistmatches)

    let queryInfo = QueryInfo(startPage: String(attributes.page))
    try container.encode(queryInfo, forKey: .query)
    try container.encode(String(attributes.totalResults), forKey: .totalResults)
    try container.encode(String(attributes.itemsPerPage), forKey: .itemsPerPage)
  }
}

/// Represents the collection of artist matches from a search.
public struct UArtistSearchMatches {
  /// Array of artists that match the search query.
  public let artist: [UArtist]
}

extension UArtistSearchMatches: Decodable {}
extension UArtistSearchMatches: Encodable {}
