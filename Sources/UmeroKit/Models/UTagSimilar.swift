//
//  UTagSimilar.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents similar tags returned from Last.fm API.
public struct UTagSimilar {
  /// Collection of similar tags.
  public let tags: [UTag]
}

extension UTagSimilar {
  enum MainKey: String, CodingKey {
    case similartags
  }

  enum CodingKeys: String, CodingKey {
    case tag
  }
}

extension UTagSimilar: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tagsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similartags)

    self.tags = try tagsContainer.decode([UTag].self, forKey: .tag)
  }
}

extension UTagSimilar: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

