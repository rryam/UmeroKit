//
//  UAlbumSearch.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the response structure for album search results from Last.fm API.
public struct UAlbumSearch {
  /// The search results containing matching albums and metadata.
  public let results: UAlbumSearchResults
}

extension UAlbumSearch {
  enum MainKey: String, CodingKey {
    case results
  }
}

extension UAlbumSearch: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    self.results = try container.decode(UAlbumSearchResults.self, forKey: .results)
  }
}

extension UAlbumSearch: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    try container.encode(results, forKey: .results)
  }
}

/// Represents the search results for albums with matches and attributes.
public struct UAlbumSearchResults {
  /// Collection of album matches found in the search.
  public let albums: UAlbumSearchMatches

  /// Search metadata including pagination information.
  public let attributes: USearchAttributes
}

private struct QueryInfo: Codable {
  let startPage: String

  enum CodingKeys: String, CodingKey {
    case startPage
  }
}

extension UAlbumSearchResults {
  enum CodingKeys: String, CodingKey {
    case albummatches = "albummatches"
    case query = "opensearch:Query"
    case totalResults = "opensearch:totalResults"
    case itemsPerPage = "opensearch:itemsPerPage"
  }
}

extension UAlbumSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.albums = try container.decode(UAlbumSearchMatches.self, forKey: .albummatches)

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

extension UAlbumSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(albums, forKey: .albummatches)

    let queryInfo = QueryInfo(startPage: String(attributes.page))
    try container.encode(queryInfo, forKey: .query)
    try container.encode(String(attributes.totalResults), forKey: .totalResults)
    try container.encode(String(attributes.itemsPerPage), forKey: .itemsPerPage)
  }
}

/// Represents the collection of album matches from a search.
public struct UAlbumSearchMatches {
  /// Array of albums that match the search query.
  public let album: [UAlbumSearchResult]
}

extension UAlbumSearchMatches: Decodable {}
extension UAlbumSearchMatches: Encodable {}
