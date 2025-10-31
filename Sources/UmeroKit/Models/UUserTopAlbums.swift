//
//  UUserTopAlbums.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a lightweight album from user top albums endpoint.
public struct UUserTopAlbum {
  /// Name of the album.
  public let name: String
  
  /// Artist information.
  public let artist: UArtistInfo
  
  /// MusicBrainz ID of the album (if available).
  public let mbid: UItemID?
  
  /// Number of times the album has been played by the user.
  public let playcount: Double
  
  /// Last.fm page for the album.
  public let url: URL
  
  /// Images associated with the album.
  public let image: [UImage]
}

extension UUserTopAlbum: Decodable {
  enum CodingKeys: String, CodingKey {
    case name, artist, mbid, playcount, url, image
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtistInfo.self, forKey: .artist)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbid.map { UItemID(rawValue: $0) }
    
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for album '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }
  }
}

extension UUserTopAlbum: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encode(String(playcount), forKey: .playcount)
  }
}

/// Represents the top albums for a user on Last.fm.
public struct UUserTopAlbums {
  /// Collection of `UUserTopAlbum` representing the top albums for the user.
  public let albums: [UUserTopAlbum]

  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserTopItemsAttributes
}

extension UUserTopAlbums {
  enum MainKey: String, CodingKey {
    case topalbums
  }

  enum CodingKeys: String, CodingKey {
    case album
    case attributes = "@attr"
  }
}

extension UUserTopAlbums: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let albumsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)

    self.albums = try albumsContainer.decode([UUserTopAlbum].self, forKey: .album)
    self.attributes = try albumsContainer.decode(UUserTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UUserTopAlbums: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var albumsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)
    
    try albumsContainer.encode(albums, forKey: .album)
    try albumsContainer.encode(attributes, forKey: .attributes)
  }
}

