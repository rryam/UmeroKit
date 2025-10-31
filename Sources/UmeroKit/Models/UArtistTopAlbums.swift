//
//  UArtistTopAlbums.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a lightweight album from artist top albums endpoint.
public struct UArtistTopAlbum {
  /// Name of the album.
  public let name: String
  
  /// Artist information.
  public let artist: UArtistInfo
  
  /// MusicBrainz ID of the album (if available).
  public let mbid: UItemID?
  
  /// Number of times the album has been played on Last.fm.
  public let playcount: Double
  
  /// Last.fm page for the album.
  public let url: URL
  
  /// Images associated with the album.
  public let image: [UImage]
}

/// Simple artist info structure for top albums/tracks responses.
public struct UArtistInfo {
  /// Name of the artist.
  public let name: String
  
  /// MusicBrainz ID of the artist (if available).
  public let mbid: UItemID?
  
  /// Last.fm page for the artist.
  public let url: URL
}

extension UArtistInfo: Decodable {
  enum CodingKeys: String, CodingKey {
    case name, mbid, url
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)
    
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbid.map { UItemID(rawValue: $0) }
  }
}

extension UArtistInfo: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
  }
}

extension UArtistTopAlbum: Decodable {
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

extension UArtistTopAlbum: Encodable {
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

/// Represents the top albums for an artist on Last.fm.
public struct UArtistTopAlbums {
  /// Collection of `UArtistTopAlbum` representing the top albums for the artist.
  public let albums: [UArtistTopAlbum]

  /// The attributes of the request like page, total pages, and total count.
  public let attributes: UArtistTopItemsAttributes
}

extension UArtistTopAlbums {
  enum MainKey: String, CodingKey {
    case topalbums
  }

  enum CodingKeys: String, CodingKey {
    case album
    case attributes = "@attr"
  }
}

extension UArtistTopAlbums: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let albumsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)

    self.albums = try albumsContainer.decode([UArtistTopAlbum].self, forKey: .album)
    self.attributes = try albumsContainer.decode(UArtistTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UArtistTopAlbums: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var albumsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums)
    try albumsContainer.encode(albums, forKey: .album)
    try albumsContainer.encode(attributes, forKey: .attributes)
  }
}

/// Represents attributes for artist top items requests.
public struct UArtistTopItemsAttributes: Codable {
  /// The artist name.
  public let artist: String

  /// The current page of the results.
  public let page: Int

  /// The number of items per page.
  public let perPage: Int

  /// The total number of pages.
  public let totalPages: Double

  /// The total number of items.
  public let total: Double
}

extension UArtistTopItemsAttributes {
  enum CodingKeys: CodingKey {
    case artist, page, perPage, totalPages, total
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    artist = try container.decode(String.self, forKey: .artist)

    // Helper function to decode numeric values from strings
    func decodeNumeric<T: LosslessStringConvertible>(_ key: CodingKeys) throws -> T {
      let stringValue = try container.decode(String.self, forKey: key)
      guard let value = T(stringValue) else {
        throw UmeroKitError.invalidDataFormat("\(key.stringValue) is not a valid number for artist '\(artist)'")
      }
      return value
    }

    let pageString = try container.decode(String.self, forKey: .page)
    let perPageString = try container.decode(String.self, forKey: .perPage)
    let totalPagesString = try container.decode(String.self, forKey: .totalPages)
    let totalString = try container.decode(String.self, forKey: .total)

    guard let page = Int(pageString) else {
      throw UmeroKitError.invalidDataFormat("Page is not a valid number for artist '\(artist)'")
    }
    self.page = page

    guard let perPage = Int(perPageString) else {
      throw UmeroKitError.invalidDataFormat("PerPage is not a valid number for artist '\(artist)'")
    }
    self.perPage = perPage

    guard let totalPages = Double(totalPagesString) else {
      throw UmeroKitError.invalidDataFormat("TotalPages is not a valid number for artist '\(artist)'")
    }
    self.totalPages = totalPages

    guard let total = Double(totalString) else {
      throw UmeroKitError.invalidDataFormat("Total is not a valid number for artist '\(artist)'")
    }
    self.total = total
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(artist, forKey: .artist)
    try container.encode(String(page), forKey: .page)
    try container.encode(String(perPage), forKey: .perPage)
    try container.encode(String(totalPages), forKey: .totalPages)
    try container.encode(String(total), forKey: .total)
  }
}
