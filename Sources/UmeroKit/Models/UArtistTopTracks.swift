//
//  UArtistTopTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top tracks for an artist on Last.fm.
public struct UArtistTopTracks {
  /// Collection of `UTrack` representing the top tracks for the artist.
  public let tracks: [UTrack]

  /// The attributes of the request like page, total pages, and total count.
  public let attributes: UArtistTopItemsAttributes
}

extension UArtistTopTracks {
  enum MainKey: String, CodingKey {
    case toptracks
  }

  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UArtistTopTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .toptracks)

    self.tracks = try tracksContainer.decode([UTrack].self, forKey: .track)
    self.attributes = try tracksContainer.decode(UArtistTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UArtistTopTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

