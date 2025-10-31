//
//  UTrackSimilar.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents similar tracks returned from Last.fm API.
public struct UTrackSimilar {
  /// Collection of similar tracks.
  public let tracks: [UTrack]
}

extension UTrackSimilar {
  enum MainKey: String, CodingKey {
    case similartracks
  }

  enum CodingKeys: String, CodingKey {
    case track
  }
}

extension UTrackSimilar: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similartracks)

    self.tracks = try tracksContainer.decode([UTrack].self, forKey: .track)
  }
}

extension UTrackSimilar: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

