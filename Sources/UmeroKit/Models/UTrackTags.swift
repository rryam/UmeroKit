//
//  UTrackTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents tags for a track from Last.fm API.
public struct UTrackTags {
  public let tags: UTags
}

extension UTrackTags {
  enum CodingKeys: String, CodingKey {
    case tags
  }
}

extension UTrackTags: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // Use try? to gracefully handle cases where tags key exists but contains invalid data
    // (e.g., empty object {} or empty string when no tags exist), allowing fallback to empty tags
    self.tags = (try? container.decode(UTags.self, forKey: .tags)) ?? UTags(tag: [])
  }
}

extension UTrackTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(tags, forKey: .tags)
  }
}
