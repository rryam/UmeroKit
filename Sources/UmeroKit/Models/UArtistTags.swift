//
//  UArtistTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents tags for an artist from Last.fm API.
public struct UArtistTags {
  public let tags: UTags
}

extension UArtistTags {
  enum CodingKeys: String, CodingKey {
    case tags
  }
}

extension UArtistTags: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // Handle nested tags structure - decode UTags directly since it's Codable
    // decodeIfPresent handles missing keys gracefully, but still throws errors for malformed data
    self.tags = try container.decodeIfPresent(UTags.self, forKey: .tags) ?? UTags(tag: [])
  }
}
