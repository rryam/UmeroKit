//
//  UUserWeeklyTrackChart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a weekly track chart entry for a user.
public struct UUserWeeklyTrackChartItem {
  /// The track name.
  public let name: String
  
  /// The artist information.
  public let artist: UArtistInfo
  
  /// The track's MusicBrainz ID (if available).
  public let mbid: UItemID?
  
  /// The number of plays during the chart period.
  public let playcount: Double
  
  /// Last.fm page for the track.
  public let url: URL
  
  /// Images associated with the track.
  public let image: [UImage]
  
  /// The rank in the chart.
  public let rank: Int
}

extension UUserWeeklyTrackChartItem {
  enum CodingKeys: String, CodingKey {
    case name
    case artist
    case mbid
    case playcount
    case url
    case image
    case rank = "@attr"
  }
  
  enum RankKeys: String, CodingKey {
    case rank
  }
}

extension UUserWeeklyTrackChartItem: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(UArtistInfo.self, forKey: .artist)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    
    let mbidString = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbidString.map { UItemID(rawValue: $0) }
    
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for track '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }
    
    // Extract rank from @attr
    let rankContainer = try container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
    let rankString = try rankContainer.decode(String.self, forKey: .rank)
    guard let rankValue = Int(rankString) else {
      throw UmeroKitError.invalidDataFormat("Rank is not a valid number for track '\(name)'")
    }
    self.rank = rankValue
  }
}

extension UUserWeeklyTrackChartItem: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encode(String(playcount), forKey: .playcount)
    
    var rankContainer = container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
    try rankContainer.encode(String(rank), forKey: .rank)
  }
}

/// Represents a weekly track chart for a user.
public struct UUserWeeklyTrackChart {
  /// Collection of weekly track chart entries.
  public let tracks: [UUserWeeklyTrackChartItem]
  
  /// The attributes of the request like user, from, and to dates.
  public let attributes: UUserWeeklyChartAttributes
}

extension UUserWeeklyTrackChart {
  enum MainKey: String, CodingKey {
    case weeklytrackchart
  }
  
  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UUserWeeklyTrackChart: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let chartContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklytrackchart)
    
    // Handle both single track and array of tracks
    if let singleTrack = try? chartContainer.decode(UUserWeeklyTrackChartItem.self, forKey: .track) {
      self.tracks = [singleTrack]
    } else {
      self.tracks = try chartContainer.decodeIfPresent([UUserWeeklyTrackChartItem].self, forKey: .track) ?? []
    }
    
    self.attributes = try chartContainer.decode(UUserWeeklyChartAttributes.self, forKey: .attributes)
  }
}

extension UUserWeeklyTrackChart: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var chartContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklytrackchart)
    
    try chartContainer.encode(tracks, forKey: .track)
    try chartContainer.encode(attributes, forKey: .attributes)
  }
}
