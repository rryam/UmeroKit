//
//  UArtistSimilar.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents similar artists returned from Last.fm API.
public struct UArtistSimilar {
  /// Collection of similar artists.
  public let artists: [UArtist]
}

extension UArtistSimilar {
  enum MainKey: String, CodingKey {
    case similarartists
  }

  enum CodingKeys: String, CodingKey {
    case artist
  }
}

extension UArtistSimilar: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let artistsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .similarartists)

    self.artists = try artistsContainer.decode([UArtist].self, forKey: .artist)
  }
}

extension UArtistSimilar: Encodable {
  public func encode(to encoder: Encoder) throws {
    // TO:DO
  }
}

