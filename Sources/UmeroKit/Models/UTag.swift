//
//  UTag.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

public struct UTag: Identifiable, Codable {
  public var id: String {
    name
  }

  public let name: String
  public let url: URL?
  public let count: Int?
  public let total: Int?
  public let reach: Double?
  public let wiki: UWiki?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decodeIfPresent(URL.self, forKey: .url)
    self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    self.total = try container.decodeIfPresent(Int.self, forKey: .total)
    self.wiki = try container.decodeIfPresent(UWiki.self, forKey: .wiki)

    let reachString = try container.decode(String.self, forKey: .reach)

    if let reach = Double(reachString) {
      self.reach = reach
    } else {
      throw NSError(domain: "Reach is not of the type Double for \(name)", code: 0)
    }
  }
}
