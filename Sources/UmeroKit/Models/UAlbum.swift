//
//  UAlbum.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents an album in Last.fm.
public struct UAlbum {

  /// Name of the album.
  public let name: String

  /// Name of the artist of the album.
  public let artist: String

  /// MusicBrainz ID of the album.
  public let mbid: UItemID?

  /// Tags applied to the album by users.
  public let tags: UTags

  /// Number of times the album has been played on Last.fm.
  public let playcount: Double

  /// Images associated with the album.
  public let image: [UImage]

  /// Last.fm page for the album.
  public let url: URL

  /// Number of listeners who have played the album on Last.fm.
  public let listeners: Double

  /// Summary for the album.
  public let wiki: UWiki
}

extension UAlbum: UItem {}

extension UAlbum: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(String.self, forKey: .artist)
    self.tags = try container.decode(UTags.self, forKey: .tags)
    self.image = try container.decode([UImage].self, forKey: .image)
    self.url = try container.decode(URL.self, forKey: .url)
    self.wiki = try container.decode(UWiki.self, forKey: .wiki)

    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    let listenersString = try container.decodeIfPresent(String.self, forKey: .listeners)
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)

    self.mbid = mbid.map { UItemID(rawValue: $0) }

    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for album '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }

    if let listenersString, !listenersString.isEmpty {
      guard let listeners = Double(listenersString) else {
        throw UmeroKitError.invalidDataFormat("Listeners is not a valid number for album '\(name)'")
      }
      self.listeners = listeners
    } else {
      self.listeners = 0
    }
  }
}
