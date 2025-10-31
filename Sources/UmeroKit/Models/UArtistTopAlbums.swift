//
//  UArtistTopAlbums.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top albums for an artist on Last.fm.
public struct UArtistTopAlbums {
  /// Collection of `UAlbum` representing the top albums for the artist.
  public let albums: [UAlbum]

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

    self.albums = try albumsContainer.decode([UAlbum].self, forKey: .album)
    self.attributes = try albumsContainer.decode(UArtistTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UArtistTopAlbums: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
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
}

