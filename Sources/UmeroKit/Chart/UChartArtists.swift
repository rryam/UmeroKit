//
//  UChart.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

public struct UChartArtists {
  public let artists: [UArtist]
  public let attributes: UChartAttributes

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
  }
}

extension UChartArtists: UChartRequestable {}
