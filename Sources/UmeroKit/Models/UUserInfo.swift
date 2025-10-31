//
//  UUserInfo.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents user information from Last.fm.
public struct UUserInfo {
  /// The user's username.
  public let name: String
  
  /// The user's real name (if set).
  public let realname: String?
  
  /// The user's profile image URL.
  public let image: [UImage]?
  
  /// The user's Last.fm profile URL.
  public let url: URL
  
  /// The user's country (if set).
  public let country: String?
  
  /// The user's age (if set).
  public let age: Int?
  
  /// The user's gender (if set).
  public let gender: String?
  
  /// Whether the user is a subscriber.
  public let subscriber: Bool?
  
  /// The number of tracks scrobbled by the user.
  public let playcount: Double?
  
  /// The number of playlists created by the user.
  public let playlists: Int?
  
  /// The number of registered users the user is following.
  public let registered: UUserRegistered?
}

/// Represents user registration information.
public struct UUserRegistered {
  /// The Unix timestamp when the user registered.
  public let unixtime: Int
  
  /// The formatted date when the user registered.
  public let text: String
}

extension UUserRegistered: Codable {
  enum CodingKeys: String, CodingKey {
    case unixtime
    case text = "#text"
  }
}

extension UUserInfo {
  enum MainKey: String, CodingKey {
    case user
  }
  
  enum CodingKeys: String, CodingKey {
    case name
    case realname
    case image
    case url
    case country
    case age
    case gender
    case subscriber
    case playcount
    case playlists
    case registered
  }
}

extension UUserInfo: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let userContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
    
    self.name = try userContainer.decode(String.self, forKey: .name)
    self.url = try userContainer.decode(URL.self, forKey: .url)
    self.image = try userContainer.decodeIfPresent([UImage].self, forKey: .image)
    self.realname = try userContainer.decodeIfPresent(String.self, forKey: .realname)
    self.country = try userContainer.decodeIfPresent(String.self, forKey: .country)
    self.gender = try userContainer.decodeIfPresent(String.self, forKey: .gender)
    
    // Parse numeric values
    if let ageString = try userContainer.decodeIfPresent(String.self, forKey: .age), !ageString.isEmpty {
      guard let ageValue = Int(ageString) else {
        throw UmeroKitError.invalidDataFormat("Age is not a valid number for user '\(name)'")
      }
      self.age = ageValue
    } else {
      self.age = nil
    }
    
    if let subscriberString = try userContainer.decodeIfPresent(String.self, forKey: .subscriber) {
      self.subscriber = NSString(string: subscriberString).boolValue
    } else {
      self.subscriber = nil
    }
    
    if let playcountString = try userContainer.decodeIfPresent(String.self, forKey: .playcount),
       !playcountString.isEmpty {
      guard let playcountValue = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat(
          "Playcount is not a valid number for user '\(name)'"
        )
      }
      self.playcount = playcountValue
    } else {
      self.playcount = nil
    }
    
    if let playlistsString = try userContainer.decodeIfPresent(String.self, forKey: .playlists),
       !playlistsString.isEmpty {
      guard let playlistsValue = Int(playlistsString) else {
        throw UmeroKitError.invalidDataFormat(
          "Playlists is not a valid number for user '\(name)'"
        )
      }
      self.playlists = playlistsValue
    } else {
      self.playlists = nil
    }
    
    self.registered = try userContainer.decodeIfPresent(UUserRegistered.self, forKey: .registered)
  }
}

extension UUserInfo: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var userContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
    
    try userContainer.encode(name, forKey: .name)
    try userContainer.encode(url, forKey: .url)
    try userContainer.encodeIfPresent(image, forKey: .image)
    try userContainer.encodeIfPresent(realname, forKey: .realname)
    try userContainer.encodeIfPresent(country, forKey: .country)
    try userContainer.encodeIfPresent(gender, forKey: .gender)
    
    if let age {
      try userContainer.encode(String(age), forKey: .age)
    }
    
    if let subscriber {
      try userContainer.encode(subscriber ? "1" : "0", forKey: .subscriber)
    }
    
    if let playcount {
      try userContainer.encode(String(playcount), forKey: .playcount)
    }
    
    if let playlists {
      try userContainer.encode(String(playlists), forKey: .playlists)
    }
    
    try userContainer.encodeIfPresent(registered, forKey: .registered)
  }
}
