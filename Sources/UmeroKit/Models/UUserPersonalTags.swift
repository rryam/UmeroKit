//
//  UUserPersonalTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a personal tag applied by a user.
public struct UUserPersonalTag {
  /// The tag name.
  public let name: String
  
  /// The number of times this tag has been used.
  public let count: Int
  
  /// The URL for the tag.
  public let url: URL
  
  /// The tagged item (artist, album, or track depending on taggingtype).
  public let item: TaggedItem
}

/// Represents the tagged item (can be artist, album, or track).
public enum TaggedItem {
  case artist(UArtist)
  case album(UAlbum)
  case track(UTrack)
}

extension TaggedItem: Codable {
  public init(from decoder: Decoder) throws {
    // Try to decode as artist first
    if let artist = try? UArtist(from: decoder) {
      self = .artist(artist)
      return
    }
    
    // Try to decode as album
    if let album = try? UAlbum(from: decoder) {
      self = .album(album)
      return
    }
    
    // Try to decode as track
    if let track = try? UTrack(from: decoder) {
      self = .track(track)
      return
    }
    
    throw DecodingError.dataCorrupted(
      DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode tagged item")
    )
  }
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .artist(let artist):
      try artist.encode(to: encoder)
    case .album(let album):
      try album.encode(to: encoder)
    case .track(let track):
      try track.encode(to: encoder)
    }
  }
}

extension UUserPersonalTag {
  enum CodingKeys: String, CodingKey {
    case name
    case count
    case url
  }
}

extension UUserPersonalTag: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)
    
    let countString = try container.decodeIfPresent(String.self, forKey: .count)
    if let countString, !countString.isEmpty {
      guard let countValue = Int(countString) else {
        throw UmeroKitError.invalidDataFormat("Count is not a valid number for tag '\(name)'")
      }
      self.count = countValue
    } else {
      self.count = 0
    }
    
    // Decode the tagged item (artist, album, or track)
    self.item = try TaggedItem(from: decoder)
  }
}

extension UUserPersonalTag: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
    try container.encode(String(count), forKey: .count)
    try item.encode(to: encoder)
  }
}

/// Represents personal tags applied by a user.
public struct UUserPersonalTags {
  /// Collection of personal tags.
  public let tags: [UUserPersonalTag]
  
  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserPersonalTagsAttributes
}

extension UUserPersonalTags {
  enum MainKey: String, CodingKey {
    case taggings
  }
  
  enum CodingKeys: String, CodingKey {
    case tag
    case attributes = "@attr"
  }
}

extension UUserPersonalTags: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let tagsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .taggings)
    
    // Handle both single tag and array of tags
    if let singleTag = try? tagsContainer.decode(UUserPersonalTag.self, forKey: .tag) {
      self.tags = [singleTag]
    } else {
      self.tags = try tagsContainer.decode([UUserPersonalTag].self, forKey: .tag)
    }
    
    self.attributes = try tagsContainer.decode(UUserPersonalTagsAttributes.self, forKey: .attributes)
  }
}

extension UUserPersonalTags: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var tagsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .taggings)
    
    try tagsContainer.encode(tags, forKey: .tag)
    try tagsContainer.encode(attributes, forKey: .attributes)
  }
}

/// Represents attributes for user personal tags requests.
public struct UUserPersonalTagsAttributes: Decodable {
  /// The username.
  public let user: String
  
  /// The current page of the results.
  public let page: Int
  
  /// The number of items per page.
  public let perPage: Int
  
  /// The total number of pages.
  public let totalPages: Int
  
  /// The total number of items.
  public let total: Int
  
  /// The type of tags (artist, album, or track).
  public let taggingtype: String?
}

extension UUserPersonalTagsAttributes {
  enum CodingKeys: CodingKey {
    case user, page, perPage, totalPages, total, taggingtype
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let userName = try container.decode(String.self, forKey: .user)
    
    func decodeNumeric<T: LosslessStringConvertible>(_ key: CodingKeys) throws -> T {
      let stringValue = try container.decode(String.self, forKey: key)
      guard let value = T(stringValue) else {
        throw UmeroKitError.invalidDataFormat("\(key.stringValue) is not a valid number for user '\(userName)'")
      }
      return value
    }
    
    self.user = userName
    self.page = try decodeNumeric(.page)
    self.perPage = try decodeNumeric(.perPage)
    self.totalPages = try decodeNumeric(.totalPages)
    self.total = try decodeNumeric(.total)
    self.taggingtype = try container.decodeIfPresent(String.self, forKey: .taggingtype)
  }
}

extension UUserPersonalTagsAttributes: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(user, forKey: .user)
    try container.encode(String(page), forKey: .page)
    try container.encode(String(perPage), forKey: .perPage)
    try container.encode(String(totalPages), forKey: .totalPages)
    try container.encode(String(total), forKey: .total)
    try container.encodeIfPresent(taggingtype, forKey: .taggingtype)
  }
}

