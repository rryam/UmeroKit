//
//  UUserWeeklyChartList.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a weekly chart list entry for a user.
public struct UUserWeeklyChartListItem: Codable {
  /// The start date of the chart period.
  public let from: Date

  /// The end date of the chart period.
  public let to: Date
}

extension UUserWeeklyChartListItem {
  enum CodingKeys: String, CodingKey {
    case from, to
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    // Decode as String first (Last.fm returns timestamps as strings), then convert to Int
    let fromString = try container.decode(String.self, forKey: .from)
    let toString = try container.decode(String.self, forKey: .to)
    
    guard let fromTimestamp = Int(fromString) else {
      throw DecodingError.dataCorruptedError(forKey: .from, in: container, debugDescription: "Invalid timestamp format")
    }
    
    guard let toTimestamp = Int(toString) else {
      throw DecodingError.dataCorruptedError(forKey: .to, in: container, debugDescription: "Invalid timestamp format")
    }

    self.from = Date(timeIntervalSince1970: TimeInterval(fromTimestamp))
    self.to = Date(timeIntervalSince1970: TimeInterval(toTimestamp))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(Int(from.timeIntervalSince1970), forKey: .from)
    try container.encode(Int(to.timeIntervalSince1970), forKey: .to)
  }
}

/// Represents the weekly chart list for a user.
public struct UUserWeeklyChartList {
  /// Collection of weekly chart list entries.
  public let chartList: [UUserWeeklyChartListItem]
}

extension UUserWeeklyChartList {
  enum MainKey: String, CodingKey {
    case weeklychartlist
  }

  enum CodingKeys: String, CodingKey {
    case chart
  }
}

extension UUserWeeklyChartList: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let chartListContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklychartlist)

    self.chartList = try chartListContainer.decode([UUserWeeklyChartListItem].self, forKey: .chart)
  }
}

extension UUserWeeklyChartList: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var chartListContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklychartlist)
    try chartListContainer.encode(chartList, forKey: .chart)
  }
}
