//
//  USearchAttributes.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the pagination and result metadata for search responses.
public struct USearchAttributes {
  /// The current page number of the search results.
  public let page: Int

  /// The total number of pages available for the search query.
  public let totalPages: Int

  /// The total number of results found for the search query.
  public let totalResults: Int

  /// The number of items per page in the search results.
  public let itemsPerPage: Int
}

extension USearchAttributes {
  enum CodingKeys: String, CodingKey {
    case page
    case totalPages = "totalPages"
    case totalResults = "total"
    case itemsPerPage = "perPage"
  }
}

extension USearchAttributes: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    // Handle both string and integer representations
    if let pageValue = try? container.decode(String.self, forKey: .page),
       let page = Int(pageValue) {
      self.page = page
    } else {
      self.page = try container.decode(Int.self, forKey: .page)
   }

    if let totalPagesValue = try? container.decode(String.self, forKey: .totalPages),
       let totalPages = Int(totalPagesValue) {
      self.totalPages = totalPages
    } else {
      self.totalPages = try container.decode(Int.self, forKey: .totalPages)
   }

    if let totalResultsValue = try? container.decode(String.self, forKey: .totalResults),
       let totalResults = Int(totalResultsValue) {
      self.totalResults = totalResults
    } else {
      self.totalResults = try container.decode(Int.self, forKey: .totalResults)
   }

    if let itemsPerPageValue = try? container.decode(String.self, forKey: .itemsPerPage),
       let itemsPerPage = Int(itemsPerPageValue) {
      self.itemsPerPage = itemsPerPage
    } else {
      self.itemsPerPage = try container.decode(Int.self, forKey: .itemsPerPage)
   }
 }
}

extension USearchAttributes: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(page, forKey: .page)
    try container.encode(totalPages, forKey: .totalPages)
    try container.encode(totalResults, forKey: .totalResults)
    try container.encode(itemsPerPage, forKey: .itemsPerPage)
  }
}
