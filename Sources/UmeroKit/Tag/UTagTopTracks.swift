//
//  UTagTopTracks.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents the top tracks for a tag on Last.fm.
public struct UTagTopTracks {
  /// Collection of `UTrack` representing the top tracks for the tag.
  public let tracks: [UTrack]

  /// The attributes of the tag request like tag, page, total pages, and total count.
  public let attributes: UTagAttributes
}

extension UTagTopTracks {
  enum MainKey: String, CodingKey {
    // Note: Last.fm API returns "tracks" as the root key, not "toptracks"
    case tracks
  }

  enum CodingKeys: String, CodingKey {
    case track
    case attributes = "@attr"
  }
}

extension UTagTopTracks: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)

    self.tracks = try tracksContainer.decode([UTrack].self, forKey: .track)
    self.attributes = try tracksContainer.decode(UTagAttributes.self, forKey: .attributes)
  }
}

extension UTagTopTracks: UTagRequestable {}

extension UTagTopTracks: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var tracksContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)
    
    try tracksContainer.encode(tracks, forKey: .track)
    try tracksContainer.encode(attributes, forKey: .attributes)
  }
}
