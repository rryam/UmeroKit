//
//  UArtist.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 28/12/22.
//

import Foundation

public struct UArtist: Codable, Identifiable {
  public var id: String {
    name
  }
  
  public let mbid: UItemID?
  public let name: String
  public let playcount: Double
  public let listeners: Double
  public let url: URL
  public let streamable: Bool
  public let image: [UImage]
}

extension UArtist {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decode([UImage].self, forKey: .image)

    let streamableString = try container.decode(String.self, forKey: .streamable)
    let playcountString = try container.decode(String.self, forKey: .playcount)
    let listenersString = try container.decode(String.self, forKey: .listeners)
    let mbid = try container.decode(String.self, forKey: .mbid)

    self.mbid = UItemID(mbid)
    self.streamable = (streamableString as NSString).boolValue

    if let playcount = Double(playcountString) {
      self.playcount = playcount
    } else {
      throw NSError(domain: "Playcount is not of the type Double for \(name)", code: 0)
    }

    if let listeners = Double(listenersString) {
      self.listeners = listeners
    } else {
      throw NSError(domain: "Listeners is not of the type Double for \(name)", code: 0)
    }
  }
}
