//
//  UUserTopTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a lightweight track from user top tracks endpoint.
public struct UUserTopTrack {
  /// Name of the track.
  public let name: String
  
  /// Artist information.
  public let artist: UArtistInfo
  
  /// MusicBrainz ID of the track (if available).
  public let mbid: UItemID?
  
  /// Number of times the track has been played by the user.
  public let playcount: Double
  
  /// Last.fm page for the track.
  public let url: URL
  
  /// Streamable flag indicating if the track can be streamed.
  public let streamable: Bool
  
  /// Images associated with the track.
  public let image: [UImage]
}

extension UUserTopTrack: Decodable {
  enum CodingKeys: String, CodingKey {
    case name, artist, mbid, playcount, url, streamable, image
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
  }
}

extension UUserTopTrack: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encode(String(playcount), forKey: .playcount)
    try container.encode(streamable ? "1" : "0", forKey: .streamable)
  }
}

/// Represents the top tracks for a user on Last.fm.
public struct UUserTopTracks {
  /// Collection of `UUserTopTrack` representing the top tracks for the user.
  public let tracks: [UUserTopTrack]

  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserTopItemsAttributes
}

extension UUserTopTracks {
  enum MainKey: String, CodingKey {
    case toptracks
  }

  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UUserTopTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .toptracks)

    self.tracks = try tracksContainer.decode([UUserTopTrack].self, forKey: .track)
    self.attributes = try tracksContainer.decode(UUserTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UUserTopTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var tracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .toptracks)
    
    try tracksContainer.encode(tracks, forKey: .track)
    try tracksContainer.encode(attributes, forKey: .attributes)
  }
}

