//
//  UAlbum.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

public struct UAlbum {
  public let name: String
  public let artist: String
  public let mbid: UItemID?
  public let tags: UTags
  public let playcount: Double
  public let image: [UImage]
  public let url: String
  public let listeners: Double
  public let wiki: UWiki
}

extension UAlbum: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(String.self, forKey: .artist)
    self.tags = try container.decode(UTags.self, forKey: .tags)
    self.image = try container.decode([UImage].self, forKey: .image)
    self.url = try container.decode(String.self, forKey: .url)
    self.wiki = try container.decode(UWiki.self, forKey: .wiki)

    let playcountString = try container.decode(String.self, forKey: .playcount)
    let listenersString = try container.decode(String.self, forKey: .listeners)
    let mbid = try container.decode(String.self, forKey: .mbid)

    self.mbid = UItemID(mbid)

    if let playcount = Double(playcountString) {
      self.playcount = playcount
    } else {
      throw NSError(domain: "Playcount is not of the type double for \(name)", code: 0)
    }

    if let listeners = Double(listenersString) {
      self.listeners = listeners
    } else {
      throw NSError(domain: "Listeners is not of the type double for \(name)", code: 0)
    }
  }
}
