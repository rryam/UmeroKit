//
//  UAlbumTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents tags for an album from Last.fm API.
public struct UAlbumTags {
  public let tags: UTags
}

extension UAlbumTags {
  enum CodingKeys: String, CodingKey {
    case tags
  }
}

extension UAlbumTags: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.tags = (try? container.decode(UTags.self, forKey: .tags)) ?? UTags(tag: [])
  }
}

extension UAlbumTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(tags, forKey: .tags)
  }
}
