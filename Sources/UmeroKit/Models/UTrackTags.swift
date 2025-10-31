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
    
    // Handle case where tags might be empty string or have nested structure
    if let tagsString = try? container.decode(String.self, forKey: .tags),
       tagsString.trimmingCharacters(in: .whitespaces).isEmpty {
      // Empty tags case
      self.tags = UTags(tag: [])
    } else {
      // Try to decode as nested UTags structure
      let tagsContainer = try container.nestedContainer(keyedBy: UTags.CodingKeys.self, forKey: .tags)
      if let tagArray = try? tagsContainer.decode([UTag].self, forKey: .tag) {
        self.tags = UTags(tag: tagArray)
      } else {
        self.tags = UTags(tag: [])
      }
    }
  }
}

extension UTags {
  enum CodingKeys: String, CodingKey {
    case tag
  }
}

extension UTrackTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}
