//
//  UGeoAttributes.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents the attributes of a geo chart.
public struct UGeoAttributes {

  /// The current country of the chart.
  public let country: String

  /// The current page of the chart.
  public let page: Int

  /// The number of items per page of the chart.
  public let perPage: Int

  /// The total number of pages for the chart.
  public let totalPages: Double

  /// The total number of items for the chart.
  public let total: Double
}

extension UGeoAttributes {
  enum CodingKeys: CodingKey {
    case country, page, perPage, totalPages, total
  }
}

extension UGeoAttributes: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    country = try container.decode(String.self, forKey: .country)

    let pageString = try container.decode(String.self, forKey: .page)
    let perPageString = try container.decode(String.self, forKey: .perPage)
    let totalPagesString = try container.decode(String.self, forKey: .totalPages)
    let totalString = try container.decode(String.self, forKey: .total)

    if let page = Int(pageString) {
      self.page = page
    } else {
      throw NSError(domain: "Page is not of the type Int.", code: 0)
    }

    if let perPage = Int(perPageString) {
      self.perPage = perPage
    } else {
      throw NSError(domain: "PerPage is not of the type Int.", code: 0)
    }

    if let totalPages = Double(totalPagesString) {
      self.totalPages = totalPages
    } else {
      throw NSError(domain: "Total Pages is not of the type Double.", code: 0)
    }

    if let total = Double(totalString) {
      self.total = total
    } else {
      throw NSError(domain: "Total is not of the type Double.", code: 0)
    }
  }

  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}
