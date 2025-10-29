//
//  UTrackSearchResult.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a lightweight track result from search API (contains only basic fields)
public struct UTrackSearchResult {
  /// Name of the track.
  public let name: String

  /// Name of the artist.
  public let artist: String

  /// URL of the track on Last.fm.
  public let url: URL

  /// Images associated with the track.
  public let image: [UImage]

  /// MusicBrainz ID of the track (if available).
  public let mbid: String?

  /// Streamable flag indicating if the track can be streamed.
  public let streamable: String
}

extension UTrackSearchResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case name, artist, url, image, mbid, streamable
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.name = try container.decode(String.self, forKey: .name)
    self.artist = try container.decode(String.self, forKey: .artist)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)
    self.mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
    self.streamable = try container.decodeIfPresent(String.self, forKey: .streamable) ?? "0"
  }
}

extension UTrackSearchResult: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(artist, forKey: .artist)
    try container.encode(url, forKey: .url)
    try container.encode(image, forKey: .image)
    try container.encodeIfPresent(mbid, forKey: .mbid)
    try container.encode(streamable, forKey: .streamable)
  }
}
