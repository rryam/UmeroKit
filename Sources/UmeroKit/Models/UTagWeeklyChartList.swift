//
//  UTagWeeklyChartList.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a weekly chart list entry for a tag.
public struct UTagWeeklyChartListItem: Codable {
  /// The start date of the chart period.
  public let from: Date

  /// The end date of the chart period.
  public let to: Date
}

extension UTagWeeklyChartListItem {
  enum CodingKeys: String, CodingKey {
    case from, to
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    // Decode as Int (Unix timestamp) - this is what Last.fm API returns
    let fromTimestamp = try container.decode(Int.self, forKey: .from)
    let toTimestamp = try container.decode(Int.self, forKey: .to)

    self.from = Date(timeIntervalSince1970: TimeInterval(fromTimestamp))
    self.to = Date(timeIntervalSince1970: TimeInterval(toTimestamp))
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(Int(from.timeIntervalSince1970), forKey: .from)
    try container.encode(Int(to.timeIntervalSince1970), forKey: .to)
  }
}

/// Represents the weekly chart list for a tag.
public struct UTagWeeklyChartList {
  /// Collection of weekly chart list entries.
  public let chartList: [UTagWeeklyChartListItem]
}

extension UTagWeeklyChartList {
  enum MainKey: String, CodingKey {
    case weeklychartlist
  }

  enum CodingKeys: String, CodingKey {
    case chart
  }
}

extension UTagWeeklyChartList: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let chartListContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .weeklychartlist)

    self.chartList = try chartListContainer.decode([UTagWeeklyChartListItem].self, forKey: .chart)
  }
}

extension UTagWeeklyChartList: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

