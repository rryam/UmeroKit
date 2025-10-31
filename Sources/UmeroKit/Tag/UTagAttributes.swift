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

    let tagName = try container.decode(String.self, forKey: .tag)

    func decodeValue<T: LosslessStringConvertible>(_ key: CodingKeys, as type: T.Type, name: String) throws -> T {
      let stringValue = try container.decode(String.self, forKey: key)
      guard let value = T(stringValue) else {
        throw UmeroKitError.invalidDataFormat("\(name) is not a valid number for tag '\(tagName)'")
      }
      return value
    }

    self.tag = tagName
    self.page = try decodeValue(.page, as: Int.self, name: "Page")
    self.perPage = try decodeValue(.perPage, as: Int.self, name: "PerPage")
    self.totalPages = try decodeValue(.totalPages, as: Double.self, name: "TotalPages")
    self.total = try decodeValue(.total, as: Double.self, name: "Total")
  }
}
