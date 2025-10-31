//
//  UArtistTopTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a lightweight track from artist top tracks endpoint.
public struct UArtistTopTrack {
  /// Name of the track.
  public let name: String
  
  /// Artist information.
  public let artist: UArtistInfo
  
  /// MusicBrainz ID of the track (if available).
  public let mbid: UItemID?
  
  /// Number of times the track has been played on Last.fm.
  public let playcount: Double
  
  /// Number of listeners who have played the track on Last.fm.
  public let listeners: Double
  
  /// Last.fm page for the track.
  public let url: URL
  
  /// Streamable flag indicating if the track can be streamed.
  public let streamable: Bool
  
  /// Images associated with the track.
  public let image: [UImage]
}

extension UArtistTopTrack: Decodable {
  enum CodingKeys: String, CodingKey {
    case name, artist, mbid, playcount, listeners, url, streamable, image
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtistInfo.self, forKey: .artist)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbid.map { UItemID(rawValue: $0) }
    
    let streamableString = try container.decodeIfPresent(String.self, forKey: .streamable)
    self.streamable = streamableString == "1"
    
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for track '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }
    
    let listenersString = try container.decodeIfPresent(String.self, forKey: .listeners)
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

extension UArtistTopTrack: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encode(String(playcount), forKey: .playcount)
    try container.encode(String(listeners), forKey: .listeners)
    try container.encode(streamable ? "1" : "0", forKey: .streamable)
  }
}

/// Represents the top tracks for an artist on Last.fm.
public struct UArtistTopTracks {
  /// Collection of `UArtistTopTrack` representing the top tracks for the artist.
  public let tracks: [UArtistTopTrack]

  /// The attributes of the request like page, total pages, and total count.
  public let attributes: UArtistTopItemsAttributes
}

extension UArtistTopTracks {
  enum MainKey: String, CodingKey {
    case toptracks
  }

  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UArtistTopTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .toptracks)

    self.tracks = try tracksContainer.decode([UArtistTopTrack].self, forKey: .track)
    self.attributes = try tracksContainer.decode(UArtistTopItemsAttributes.self, forKey: .attributes)
  }
}
