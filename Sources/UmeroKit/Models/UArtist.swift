//
//  UArtist.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 28/12/22.
//

import Foundation

/// Represents an artist in Last.fm.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
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

extension UArtist: UItem {}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension UArtist: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)

    self.image = try container.decodeIfPresent([UImage].self, forKey: .image)

    let streamableString = try container.decodeIfPresent(String.self, forKey: .streamable)
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    let listenersString = try container.decodeIfPresent(String.self, forKey: .listeners)
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)

    self.mbid = mbid.map { UItemID(rawValue: $0) }

    if let streamableString, !streamableString.isEmpty {
      self.streamable = NSString(string: streamableString).boolValue
    } else {
      self.streamable = nil
    }

    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for artist '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = nil
    }

    if let listenersString, !listenersString.isEmpty {
      guard let listeners = Double(listenersString) else {
        throw UmeroKitError.invalidDataFormat("Listeners is not a valid number for artist '\(name)'")
      }
      self.listeners = listeners
    } else {
      self.listeners = nil
    }
  }
}
