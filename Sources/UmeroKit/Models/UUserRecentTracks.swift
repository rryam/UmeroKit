//
//  UUserRecentTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Lightweight artist info structure for recent tracks (only name and mbid, no url).
public struct URecentTrackArtist {
  /// Name of the artist.
  public let name: String
  
  /// MusicBrainz ID of the artist (if available).
  public let mbid: UItemID?
}

extension URecentTrackArtist {
  enum CodingKeys: String, CodingKey {
    case mbid
    case text = "#text"
  }
}

extension URecentTrackArtist: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // API returns artist name as #text, not name
    self.name = try container.decode(String.self, forKey: .text)
    
    let mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbid.map { UItemID(rawValue: $0) }
  }
}

extension URecentTrackArtist: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .text)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
  }
}

/// Represents a recent track scrobbled by a user.
public struct UUserRecentTrack {
  /// The track name.
  public let name: String
  
  /// The artist information.
  public let artist: URecentTrackArtist
  
  /// The date and time when the track was scrobbled.
  public let date: Date?
  
  /// Whether the user has loved this track.
  public let loved: Bool?
  
  /// The album name (if available).
  public let album: String?
  
  /// The album's MusicBrainz ID (if available).
  public let albumMbid: UItemID?
  
  /// The track's MusicBrainz ID (if available).
  public let mbid: UItemID?
  
  /// Last.fm page for the track.
  public let url: URL?
  
  /// Images associated with the track.
  public let image: [UImage]?
  
  /// Streamable flag (if available).
  public let streamable: Bool?
}

extension UUserRecentTrack {
  enum CodingKeys: String, CodingKey {
    case name
    case artist
    case date
    case loved
    case album
    case albumMbid = "album_mbid"
    case mbid
    case url
    case image
    case streamable
  }
  
  enum DateKeys: String, CodingKey {
    case timestamp = "uts"
    case text = "#text"
  }
}

extension UUserRecentTrack: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(URecentTrackArtist.self, forKey: .artist)
    
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
    
    let lovedString = try container.decodeIfPresent(String.self, forKey: .loved)
    self.loved = lovedString == "1"
    
    self.album = try container.decodeIfPresent(String.self, forKey: .album)
    
    let albumMbidString = try container.decodeIfPresent(String.self, forKey: .albumMbid)
    self.albumMbid = albumMbidString.map { UItemID(rawValue: $0) }
    
    let mbidString = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbidString.map { UItemID(rawValue: $0) }
    
    self.url = try container.decodeIfPresent(URL.self, forKey: .url)
    self.image = try container.decodeIfPresent([UImage].self, forKey: .image)
    
    let streamableString = try container.decodeIfPresent(String.self, forKey: .streamable)
    self.streamable = streamableString == "1"
  }
}

extension UUserRecentTrack: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    
    if let date {
      var dateContainer = container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
      try dateContainer.encode(String(Int(date.timeIntervalSince1970)), forKey: .timestamp)
    }
    
    if let loved {
      try container.encode(loved ? "1" : "0", forKey: .loved)
    }
    
    try container.encodeIfPresent(album, forKey: .album)
    try container.encodeIfPresent(albumMbid?.rawValue, forKey: .albumMbid)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encodeIfPresent(url, forKey: .url)
    try container.encodeIfPresent(image, forKey: .image)
    
    if let streamable {
      try container.encode(streamable ? "1" : "0", forKey: .streamable)
    }
  }
}

/// Represents recent tracks scrobbled by a user.
public struct UUserRecentTracks {
  /// Collection of recent tracks.
  public let tracks: [UUserRecentTrack]
  
  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserRecentTracksAttributes
}

extension UUserRecentTracks {
  enum MainKey: String, CodingKey {
    case recenttracks
  }
  
  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UUserRecentTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recenttracks)
    
    // Handle both single track and array of tracks
    if let singleTrack = try? tracksContainer.decode(UUserRecentTrack.self, forKey: .track) {
      self.tracks = [singleTrack]
    } else {
      self.tracks = try tracksContainer.decode([UUserRecentTrack].self, forKey: .track)
    }
    
    self.attributes = try tracksContainer.decode(UUserRecentTracksAttributes.self, forKey: .attributes)
  }
}

extension UUserRecentTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var tracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recenttracks)
    
    try tracksContainer.encode(tracks, forKey: .track)
    try tracksContainer.encode(attributes, forKey: .attributes)
  }
}

/// Represents attributes for user recent tracks requests.
public struct UUserRecentTracksAttributes: Decodable {
  /// The username.
  public let user: String
  
  /// The current page of the results.
  public let page: Int
  
  /// The number of items per page.
  public let perPage: Int
  
  /// The total number of pages.
  public let totalPages: Int
  
  /// The total number of items.
  public let total: Int
}

extension UUserRecentTracksAttributes {
  enum CodingKeys: CodingKey {
    case user, page, perPage, totalPages, total
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let userName = try container.decode(String.self, forKey: .user)
    
    func decodeNumeric<T: LosslessStringConvertible>(_ key: CodingKeys) throws -> T {
      let stringValue = try container.decode(String.self, forKey: key)
      guard let value = T(stringValue) else {
        throw UmeroKitError.invalidDataFormat("\(key.stringValue) is not a valid number for user '\(userName)'")
      }
      return value
    }
    
    self.user = userName
    self.page = try decodeNumeric(.page)
    self.perPage = try decodeNumeric(.perPage)
    self.totalPages = try decodeNumeric(.totalPages)
    self.total = try decodeNumeric(.total)
  }
}

extension UUserRecentTracksAttributes: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(user, forKey: .user)
    try container.encode(String(page), forKey: .page)
    try container.encode(String(perPage), forKey: .perPage)
    try container.encode(String(totalPages), forKey: .totalPages)
    try container.encode(String(total), forKey: .total)
  }
}
