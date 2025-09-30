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

    guard let page = Int(pageString) else {
      throw UmeroKitError.invalidDataFormat("Page is not a valid number for geo chart")
    }
    self.page = page

    guard let perPage = Int(perPageString) else {
      throw UmeroKitError.invalidDataFormat("PerPage is not a valid number for geo chart")
    }
    self.perPage = perPage

    guard let totalPages = Double(totalPagesString) else {
      throw UmeroKitError.invalidDataFormat("TotalPages is not a valid number for geo chart")
    }
    self.totalPages = totalPages

    guard let total = Double(totalString) else {
      throw UmeroKitError.invalidDataFormat("Total is not a valid number for geo chart")
    }
    self.total = total
  }

  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}
