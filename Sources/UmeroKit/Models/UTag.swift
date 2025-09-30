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

    let reachString = try container.decodeIfPresent(String.self, forKey: .reach)

    if let reachString, !reachString.isEmpty {
      guard let reach = Double(reachString) else {
        throw UmeroKitError.invalidDataFormat("Reach is not a valid number for tag '\(name)'")
      }
      self.reach = reach
    } else {
      self.reach = nil
    }
  }
}
