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

extension UAlbumSearchResults {
  enum CodingKeys: String, CodingKey {
    case albummatches = "albummatches"
    case attributes = "opensearch:Query"
  }
}

extension UAlbumSearchResults: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.albums = try container.decode(UAlbumSearchMatches.self, forKey: .albummatches)

    // The attributes are usually nested in the "opensearch:Query" field
    if let queryAttributes = try? container.decodeIfPresent(USearchAttributes.self, forKey: .attributes) {
      self.attributes = queryAttributes
    } else {
      // If opensearch:Query doesn't exist, create reasonable defaults based on response content
      let itemCount = albums.album.count
      self.attributes = USearchAttributes(
        page: 1,
        totalPages: itemCount > 0 ? 1 : 0,
        totalResults: itemCount,
        itemsPerPage: itemCount > 0 ? itemCount : 30
      )
    }
  }
}

extension UAlbumSearchResults: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(albums, forKey: .albummatches)
    try container.encode(attributes, forKey: .attributes)
  }
}

/// Represents the collection of album matches from a search.
public struct UAlbumSearchMatches {
  /// Array of albums that match the search query.
  public let album: [UAlbumSearchResult]
}

extension UAlbumSearchMatches: Decodable {}
extension UAlbumSearchMatches: Encodable {}
