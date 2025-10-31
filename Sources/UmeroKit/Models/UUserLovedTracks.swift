//
//  UUserLovedTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a loved track by a user.
public struct UUserLovedTrack {
  /// The track name.
  public let name: String
  
  /// The artist information.
  public let artist: UArtistInfo
  
  /// The track's MusicBrainz ID (if available).
  public let mbid: UItemID?
  
  /// Last.fm page for the track.
  public let url: URL
  
  /// Images associated with the track.
  public let image: [UImage]
  
  /// The date when the track was loved.
  public let date: Date?
}

extension UUserLovedTrack {
  enum CodingKeys: String, CodingKey {
    case name
    case artist
    case mbid
    case url
    case image
    case date
  }
  
  enum DateKeys: String, CodingKey {
    case timestamp = "uts"
    case text = "#text"
  }
}

extension UUserLovedTrack: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtistInfo.self, forKey: .artist)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    
    let mbidString = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbidString.map { UItemID(rawValue: $0) }
    
    // Date parsing
    if let dateContainer = try? container.nestedContainer(keyedBy: DateKeys.self, forKey: .date) {
      let timestampString = try dateContainer.decode(String.self, forKey: .timestamp)
      if let timestamp = Int(timestampString) {
        self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
      } else {
        self.date = nil
      }
    } else {
      self.date = nil
    }
  }
}

extension UUserLovedTrack: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    
    if let date {
      var dateContainer = container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
      try dateContainer.encode(String(Int(date.timeIntervalSince1970)), forKey: .timestamp)
    }
  }
}

/// Represents loved tracks by a user.
public struct UUserLovedTracks {
  /// Collection of loved tracks.
  public let tracks: [UUserLovedTrack]
  
  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserTopItemsAttributes
}

extension UUserLovedTracks {
  enum MainKey: String, CodingKey {
    case lovedtracks
  }
  
  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UUserLovedTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .lovedtracks)
    
    // Handle both single track and array of tracks
    if let singleTrack = try? tracksContainer.decode(UUserLovedTrack.self, forKey: .track) {
      self.tracks = [singleTrack]
    } else {
      self.tracks = try tracksContainer.decode([UUserLovedTrack].self, forKey: .track)
    }
    
    self.attributes = try tracksContainer.decode(UUserTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UUserLovedTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var tracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .lovedtracks)
    
    try tracksContainer.encode(tracks, forKey: .track)
    try tracksContainer.encode(attributes, forKey: .attributes)
  }
}

