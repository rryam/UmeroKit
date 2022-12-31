//
//  UChartTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a chart of top tracks.
public struct UChartTracks {

  /// Collection of `UTrack` representing the top tracks on the chart.
  public let tracks: [UTrack]

  /// The attributes of the chart like page, total pages, and total count.
  public let attributes: UChartAttributes
}

extension UChartTracks {
  enum MainKey: String, CodingKey {
    case tracks
  }

  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UChartTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)

    self.tracks = try artistsContainer.decode([UTrack].self, forKey: .track)
    self.attributes = try artistsContainer.decode(UChartAttributes.self, forKey: .attributes)
  }
}

extension UChartTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
  }
}

extension UChartTracks: UChartRequestable {}
