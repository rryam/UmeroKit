//
//  UUserTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents tags applied by a user on Last.fm.
public struct UUserTags {
  /// The tags applied by the user.
  public let tags: UTags
}

extension UUserTags {
  enum CodingKeys: String, CodingKey {
    case tags
  }
}

extension UUserTags: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    enum TagsContainerKeys: String, CodingKey {
      case tag
      // The "@attr" key is intentionally ignored as it's not used.
    }
    
    if container.contains(.tags) {
      let tagsContainer = try container.nestedContainer(keyedBy: TagsContainerKeys.self, forKey: .tags)
      let tagArray = try tagsContainer.decodeIfPresent([UTag].self, forKey: .tag) ?? []
      self.tags = UTags(tag: tagArray)
    } else {
      self.tags = UTags(tag: [])
    }
  }
}

extension UUserTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(tags, forKey: .tags)
  }
}

