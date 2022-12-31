//
//  UChart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a chart of top artists.
public struct UChartArtists {
  /// Collection of `UArtist` representing the top artists on the chart.
  public let artists: [UArtist]

  /// The attributes of the chart like page, total pages, and total count.
  public let attributes: UChartAttributes
}

extension UChartArtists {
  enum MainKey: String, CodingKey {
    case artists
  }

  enum CodingKeys: String, CodingKey {
    case artist
    case attributes = "@attr"
  }
}

extension UChartArtists: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .artists)

    self.artists = try artistsContainer.decode([UArtist].self, forKey: .artist)
    self.attributes = try artistsContainer.decode(UChartAttributes.self, forKey: .attributes)
  }
}

extension UChartArtists: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

extension UChartArtists: UChartRequestable {}
