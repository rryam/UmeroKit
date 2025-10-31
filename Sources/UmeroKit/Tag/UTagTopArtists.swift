//
//  UTagTopArtists.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top artists for a tag on Last.fm.
public struct UTagTopArtists {
  /// Collection of `UArtist` representing the top artists for the tag.
  public let artists: [UArtist]

  /// The attributes of the tag request like tag, page, total pages, and total count.
  public let attributes: UTagAttributes
}

extension UTagTopArtists {
  enum MainKey: String, CodingKey {
    case topartists
  }

  enum CodingKeys: String, CodingKey {
    case artist
    case attributes = "@attr"
  }
}

extension UTagTopArtists: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)

    self.artists = try artistsContainer.decode([UArtist].self, forKey: .artist)
    self.attributes = try artistsContainer.decode(UTagAttributes.self, forKey: .attributes)
  }
}

extension UTagTopArtists: UTagRequestable {}

extension UTagTopArtists: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var artistsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topartists)
    
    try artistsContainer.encode(artists, forKey: .artist)
    try artistsContainer.encode(attributes, forKey: .attributes)
  }
}
