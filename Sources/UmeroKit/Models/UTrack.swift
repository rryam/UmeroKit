//
//  UTrack.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a track in Last.fm.
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

extension UTrack: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtist.self, forKey: .artist)
    self.image = try container.decode([UImage].self, forKey: .image)
    self.url = try container.decode(URL.self, forKey: .url)

    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    let listenersString = try container.decodeIfPresent(String.self, forKey: .listeners)
    let durationString = try container.decodeIfPresent(String.self, forKey: .duration)
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)

    self.mbid = mbid.map { UItemID(rawValue: $0) }

    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for track '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }

    if let durationString, !durationString.isEmpty {
      guard let duration = Int(durationString) else {
        throw UmeroKitError.invalidDataFormat("Duration is not a valid number for track '\(name)'")
      }
      self.duration = duration
    } else {
      self.duration = 0
    }

    if let listenersString, !listenersString.isEmpty {
      guard let listeners = Double(listenersString) else {
        throw UmeroKitError.invalidDataFormat("Listeners is not a valid number for track '\(name)'")
      }
      self.listeners = listeners
    } else {
      self.listeners = 0
    }
  }
}
