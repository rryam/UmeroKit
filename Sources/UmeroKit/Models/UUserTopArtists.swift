//
//  UUserTopArtists.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top artists for a user on Last.fm.
public struct UUserTopArtists {
  /// Collection of `UArtist` representing the top artists for the user.
  public let artists: [UArtist]

  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserTopItemsAttributes
}

extension UUserTopArtists {
  enum MainKey: String, CodingKey {
    case topartists
  }

  enum CodingKeys: String, CodingKey {
    case artist
    case attributes = "@attr"
  }
}

extension UUserTopArtists: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)

    self.artists = try artistsContainer.decode([UArtist].self, forKey: .artist)
    self.attributes = try artistsContainer.decode(UUserTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UUserTopArtists: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var artistsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)
    
    try artistsContainer.encode(artists, forKey: .artist)
    try artistsContainer.encode(attributes, forKey: .attributes)
  }
}

/// Represents attributes for user top items requests.
public struct UUserTopItemsAttributes: Decodable {
  /// The username.
  public let user: String

  /// The current page of the results.
  public let page: Int

  /// The number of items per page.
  public let perPage: Int

  /// The total number of pages.
  public let totalPages: Int

  /// The total number of items.
  public let total: Int
  
  /// The time period (optional).
  public let period: String?
}

extension UUserTopItemsAttributes {
  enum CodingKeys: CodingKey {
    case user, page, perPage, totalPages, total, period
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let userName = try container.decode(String.self, forKey: .user)

    // Helper function to decode numeric values from strings
    func decodeNumeric<T: LosslessStringConvertible>(_ key: CodingKeys) throws -> T {
      let stringValue = try container.decode(String.self, forKey: key)
      guard let value = T(stringValue) else {
        throw UmeroKitError.invalidDataFormat("\(key.stringValue) is not a valid number for user '\(userName)'")
      }
      return value
    }

    self.user = userName
    self.page = try decodeNumeric(.page)
    self.perPage = try decodeNumeric(.perPage)
    self.totalPages = try decodeNumeric(.totalPages)
    self.total = try decodeNumeric(.total)
    self.period = try container.decodeIfPresent(String.self, forKey: .period)
  }
}

extension UUserTopItemsAttributes: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(user, forKey: .user)
    try container.encode(String(page), forKey: .page)
    try container.encode(String(perPage), forKey: .perPage)
    try container.encode(String(totalPages), forKey: .totalPages)
    try container.encode(String(total), forKey: .total)
    try container.encodeIfPresent(period, forKey: .period)
  }
}
