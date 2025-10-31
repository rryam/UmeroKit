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
    
    // Handle nested tags structure
    let tagsContainer = try container.nestedContainer(keyedBy: UTags.CodingKeys.self, forKey: .tags)
    if let tagArray = try? tagsContainer.decode([UTag].self, forKey: .tag) {
      self.tags = UTags(tag: tagArray)
    } else {
      self.tags = UTags(tag: [])
    }
  }
}

extension UArtistTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

