//
//  UUserWeeklyArtistChart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a weekly artist chart entry for a user.
public struct UUserWeeklyArtistChartItem {
  /// The artist name.
  public let name: String
  
  /// The artist's MusicBrainz ID (if available).
  public let mbid: UItemID?
  
  /// The number of plays during the chart period.
  public let playcount: Double
  
  /// Last.fm page for the artist.
  public let url: URL
  
  /// Images associated with the artist.
  public let image: [UImage]
  
  /// The rank in the chart.
  public let rank: Int
}

extension UUserWeeklyArtistChartItem {
  enum CodingKeys: String, CodingKey {
    case name
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

extension UUserWeeklyArtistChartItem: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    
    let mbidString = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.mbid = mbidString.map { UItemID(rawValue: $0) }
    
    let playcountString = try container.decodeIfPresent(String.self, forKey: .playcount)
    if let playcountString, !playcountString.isEmpty {
      guard let playcount = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for artist '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }
    
    // Extract rank from @attr
    let rankContainer = try container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
    let rankString = try rankContainer.decode(String.self, forKey: .rank)
    guard let rankValue = Int(rankString) else {
      throw UmeroKitError.invalidDataFormat("Rank is not a valid number for artist '\(name)'")
    }
    self.rank = rankValue
  }
}

extension UUserWeeklyArtistChartItem: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid?.rawValue, forKey: .mbid)
    try container.encode(String(playcount), forKey: .playcount)
    
    var rankContainer = container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
    try rankContainer.encode(String(rank), forKey: .rank)
  }
}

/// Represents a weekly artist chart for a user.
public struct UUserWeeklyArtistChart {
  /// Collection of weekly artist chart entries.
  public let artists: [UUserWeeklyArtistChartItem]
  
  /// The attributes of the request like user, from, and to dates.
  public let attributes: UUserWeeklyChartAttributes
}

extension UUserWeeklyArtistChart {
  enum MainKey: String, CodingKey {
    case weeklyartistchart
  }
  
  enum CodingKeys: String, CodingKey {
    case artist
    case attributes = "@attr"
  }
}

extension UUserWeeklyArtistChart: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let chartContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklyartistchart)
    
    // Handle both single artist and array of artists
    if let singleArtist = try? chartContainer.decode(UUserWeeklyArtistChartItem.self, forKey: .artist) {
      self.artists = [singleArtist]
    } else {
      self.artists = try chartContainer.decode([UUserWeeklyArtistChartItem].self, forKey: .artist)
    }
    
    self.attributes = try chartContainer.decode(UUserWeeklyChartAttributes.self, forKey: .attributes)
  }
}

extension UUserWeeklyArtistChart: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var chartContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklyartistchart)
    
    try chartContainer.encode(artists, forKey: .artist)
    try chartContainer.encode(attributes, forKey: .attributes)
  }
}

