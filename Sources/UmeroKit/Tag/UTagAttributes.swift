//
//  UTagAttributes.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the attributes of a tag request response.
public struct UTagAttributes {

  /// The tag name.
  public let tag: String

  /// The current page of the results.
  public let page: Int

  /// The number of items per page.
  public let perPage: Int

  /// The total number of pages.
  public let totalPages: Double

  /// The total number of items.
  public let total: Double
}

extension UTagAttributes {
  enum CodingKeys: CodingKey {
    case tag, page, perPage, totalPages, total
  }
}

extension UTagAttributes: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    tag = try container.decode(String.self, forKey: .tag)

    let pageString = try container.decode(String.self, forKey: .page)
    let perPageString = try container.decode(String.self, forKey: .perPage)
    let totalPagesString = try container.decode(String.self, forKey: .totalPages)
    let totalString = try container.decode(String.self, forKey: .total)

    guard let page = Int(pageString) else {
      throw UmeroKitError.invalidDataFormat("Page is not a valid number for tag '\(tag)'")
    }
    self.page = page

    guard let perPage = Int(perPageString) else {
      throw UmeroKitError.invalidDataFormat("PerPage is not a valid number for tag '\(tag)'")
    }
    self.perPage = perPage

    guard let totalPages = Double(totalPagesString) else {
      throw UmeroKitError.invalidDataFormat("TotalPages is not a valid number for tag '\(tag)'")
    }
    self.totalPages = totalPages

    guard let total = Double(totalString) else {
      throw UmeroKitError.invalidDataFormat("Total is not a valid number for tag '\(tag)'")
    }
    self.total = total
  }

  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

