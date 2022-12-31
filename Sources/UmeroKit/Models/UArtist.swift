//
//  UArtist.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 28/12/22.
//

import Foundation

/// Represents an artist in Last.fm.
public struct UArtist {
  /// MusicBrainz ID of the artist.
  public let mbid: UItemID?

  /// Name of the artist.
  public let name: String

  /// Last.fm page for the artist.
  public let url: URL

  /// Number of times the artist has been played on Last.fm.
  public let playcount: Double?

  /// Number of listeners who have played the artist on Last.fm.
  public let listeners: Double?

  public let streamable: Bool?

  public let image: [UImage]?
}

extension UArtist: Identifiable {
  public var id: String {
    url.absoluteString
  }
}

extension UArtist: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)

    self.image = try container.decodeIfPresent([UImage].self, forKey: .image)

    let streamableString = try container.decodeIfPresent(String.self, forKey: .streamable)
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    let listenersString = try container.decodeIfPresent(String.self, forKey: .listeners)
    let mbid = try container.decode(String.self, forKey: .mbid)

    self.mbid = UItemID(mbid)

    if let streamable = (streamableString as? NSString)?.boolValue {
      self.streamable = streamable
    } else {
      self.streamable = nil
    }

    if let playcountString, let playcount = Double(playcountString) {
      self.playcount = playcount
    } else {
      self.playcount = nil
    }

    if let listenersString, let listeners = Double(listenersString) {
      self.listeners = listeners
    } else {
      self.listeners = nil
    }
  }
}
