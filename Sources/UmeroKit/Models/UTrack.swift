//
//  UTrack.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a track in Last.fm.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct UTrack {
  public let name: String
  public let duration: Int
  public let playcount: Double
  public let listeners: Double
  public let mbid: UItemID?
  public let url: URL
  public let artist: UArtist
  public let image: [UImage]
}

extension UTrack: UItem {}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension UTrack: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtist.self, forKey: .artist)
    self.image = try container.decode([UImage].self, forKey: .image)
    self.url = try container.decode(URL.self, forKey: .url)

    let playcountString = try container.decode(String.self, forKey: .playcount)
    let listenersString = try container.decode(String.self, forKey: .listeners)
    let durationString = try container.decode(String.self, forKey: .duration)
    let mbid = try container.decode(String.self, forKey: .mbid)

    self.mbid = UItemID(mbid)

    if let playcount = Double(playcountString) {
      self.playcount = playcount
    } else {
      throw NSError(domain: "Playcount is not of the type double for \(name)", code: 0)
    }

    if let duration = Int(durationString) {
      self.duration = duration
    } else {
      throw NSError(domain: "Duration is not of the type Int for \(name)", code: 0)
    }

    if let listeners = Double(listenersString) {
      self.listeners = listeners
    } else {
      throw NSError(domain: "Listeners is not of the type double for \(name)", code: 0)
    }
  }
}
