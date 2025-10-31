//
//  UUserWeeklyAlbumChart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a weekly album chart entry for a user.
public struct UUserWeeklyAlbumChartItem {
  /// The album name.
  public let name: String
  
  /// The artist information.
  public let artist: UArtistInfo
  
  /// The album's MusicBrainz ID (if available).
  public let mbid: UItemID?
  
  /// The number of plays during the chart period.
  public let playcount: Double
  
  /// Last.fm page for the album.
  public let url: URL
  
  /// Images associated with the album.
  public let image: [UImage]
  
  /// The rank in the chart.
  public let rank: Int
}

extension UUserWeeklyAlbumChartItem {
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

extension UUserWeeklyAlbumChartItem: Decodable {
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
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for album '\(name)'")
      }
      self.playcount = playcount
    } else {
      self.playcount = 0
    }
    
    // Extract rank from @attr
    let rankContainer = try container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
    let rankString = try rankContainer.decode(String.self, forKey: .rank)
    guard let rankValue = Int(rankString) else {
      throw UmeroKitError.invalidDataFormat("Rank is not a valid number for album '\(name)'")
    }
    self.rank = rankValue
  }
}

extension UUserWeeklyAlbumChartItem: Encodable {
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

/// Represents a weekly album chart for a user.
public struct UUserWeeklyAlbumChart {
  /// Collection of weekly album chart entries.
  public let albums: [UUserWeeklyAlbumChartItem]
  
  /// The attributes of the request like user, from, and to dates.
  public let attributes: UUserWeeklyChartAttributes
}

extension UUserWeeklyAlbumChart {
  enum MainKey: String, CodingKey {
    case weeklyalbumchart
  }
  
  enum CodingKeys: String, CodingKey {
    case album
    case attributes = "@attr"
  }
}

extension UUserWeeklyAlbumChart: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let chartContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklyalbumchart)
    
    // Handle both single album and array of albums
    if let singleAlbum = try? chartContainer.decode(UUserWeeklyAlbumChartItem.self, forKey: .album) {
      self.albums = [singleAlbum]
    } else {
      self.albums = try chartContainer.decode([UUserWeeklyAlbumChartItem].self, forKey: .album)
    }
    
    self.attributes = try chartContainer.decode(UUserWeeklyChartAttributes.self, forKey: .attributes)
  }
}

extension UUserWeeklyAlbumChart: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var chartContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklyalbumchart)
    
    try chartContainer.encode(albums, forKey: .album)
    try chartContainer.encode(attributes, forKey: .attributes)
  }
}

/// Represents attributes for user weekly chart requests.
public struct UUserWeeklyChartAttributes: Decodable {
  /// The username.
  public let user: String
  
  /// The start date of the chart period.
  public let from: Date
  
  /// The end date of the chart period.
  public let to: Date
}

extension UUserWeeklyChartAttributes {
  enum CodingKeys: String, CodingKey {
    case user
    case from
    case to
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.user = try container.decode(String.self, forKey: .user)
    
    let fromString = try container.decode(String.self, forKey: .from)
    let toString = try container.decode(String.self, forKey: .to)
    
    guard let fromTimestamp = Int(fromString) else {
      throw UmeroKitError.invalidDataFormat("From timestamp is not valid for user '\(user)'")
    }
    
    guard let toTimestamp = Int(toString) else {
      throw UmeroKitError.invalidDataFormat("To timestamp is not valid for user '\(user)'")
    }
    
    self.from = Date(timeIntervalSince1970: TimeInterval(fromTimestamp))
    self.to = Date(timeIntervalSince1970: TimeInterval(toTimestamp))
  }
}

extension UUserWeeklyChartAttributes: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(user, forKey: .user)
    try container.encode(String(Int(from.timeIntervalSince1970)), forKey: .from)
    try container.encode(String(Int(to.timeIntervalSince1970)), forKey: .to)
  }
}
