//
//  UTagTopAlbums.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top albums for a tag on Last.fm.
public struct UTagTopAlbums {
  /// Collection of `UAlbum` representing the top albums for the tag.
  public let albums: [UAlbum]

  /// The attributes of the tag request like tag, page, total pages, and total count.
  public let attributes: UTagAttributes
}

extension UTagTopAlbums {
  enum MainKey: String, CodingKey {
    // Note: Last.fm API returns "albums" as the root key, not "topalbums"
    case albums
  }

  enum CodingKeys: String, CodingKey {
    case album
    case attributes = "@attr"
  }
}

extension UTagTopAlbums: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let albumsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .albums)

    self.albums = try albumsContainer.decode([UAlbum].self, forKey: .album)
    self.attributes = try albumsContainer.decode(UTagAttributes.self, forKey: .attributes)
  }
}

extension UTagTopAlbums: UTagRequestable {}

extension UTagTopAlbums: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var albumsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .albums)
    
    try albumsContainer.encode(albums, forKey: .album)
    try albumsContainer.encode(attributes, forKey: .attributes)
  }
}
