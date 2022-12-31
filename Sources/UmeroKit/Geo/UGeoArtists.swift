//
//  UGeoArtists.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents the most popular artists on Last.fm by country.
public struct UGeoArtists {
  /// Collection of `UArtist` as the most popular artists on Last.fm by country.
  public let artists: [UArtist]

  /// The attributes of the chart like country, page, total pages, and total count.
  public let attributes: UGeoAttributes
}

extension UGeoArtists {
  enum MainKey: String, CodingKey {
    case topartists
  }

  enum CodingKeys: String, CodingKey {
    case artist
    case attributes = "@attr"
  }
}

extension UGeoArtists: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)

    self.artists = try artistsContainer.decode([UArtist].self, forKey: .artist)
    self.attributes = try artistsContainer.decode(UGeoAttributes.self, forKey: .attributes)
  }
}

extension UGeoArtists: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

extension UGeoArtists: UGeoRequestable {}
