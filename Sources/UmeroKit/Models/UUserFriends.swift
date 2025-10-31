//
//  UUserFriends.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a friend of a user.
public struct UUserFriend {
  /// The friend's username.
  public let name: String
  
  /// The friend's profile image.
  public let image: [UImage]?
  
  /// The friend's Last.fm profile URL.
  public let url: URL
  
  /// The date when the users became friends.
  public let date: Date?
  
  /// Whether the friend is a subscriber.
  public let subscriber: Bool?
}

extension UUserFriend {
  enum CodingKeys: String, CodingKey {
    case name
    case image
    case url
    case subscriber
    case date
  }
  
  enum DateKeys: String, CodingKey {
    case timestamp = "uts"
    case text = "#text"
  }
}

extension UUserFriend: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decode(URL.self, forKey: .url)
    self.image = try container.decodeIfPresent([UImage].self, forKey: .image)
    
    let subscriberString = try container.decodeIfPresent(String.self, forKey: .subscriber)
    self.subscriber = subscriberString.map { $0 == "1" }
    
    // Date parsing
    if let dateContainer = try? container.nestedContainer(keyedBy: DateKeys.self, forKey: .date) {
      let timestampString = try dateContainer.decode(String.self, forKey: .timestamp)
      guard let timestamp = Int(timestampString) else {
        throw UmeroKitError.invalidDataFormat("Date timestamp for friend '\(name)' is not a valid number.")
      }
      self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    } else {
      self.date = nil
    }
  }
}

extension UUserFriend: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
    try container.encodeIfPresent(image, forKey: .image)
    
    if let subscriber {
      try container.encode(subscriber ? "1" : "0", forKey: .subscriber)
    }
    
    if let date {
      var dateContainer = container.nestedContainer(keyedBy: DateKeys.self, forKey: .date)
      try dateContainer.encode(String(Int(date.timeIntervalSince1970)), forKey: .timestamp)
    }
  }
}

/// Represents a list of friends for a user.
public struct UUserFriends {
  /// Collection of friends.
  public let friends: [UUserFriend]
  
  /// The attributes of the request like user, page, total pages, and total count.
  public let attributes: UUserTopItemsAttributes
}

extension UUserFriends {
  enum MainKey: String, CodingKey {
    case friends
  }
  
  enum CodingKeys: String, CodingKey {
    case user
    case attributes = "@attr"
  }
}

extension UUserFriends: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MainKey.self)
    let friendsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .friends)
    
    // Handle both single friend and array of friends
    if let singleFriend = try? friendsContainer.decode(UUserFriend.self, forKey: .user) {
      self.friends = [singleFriend]
    } else {
      self.friends = try friendsContainer.decode([UUserFriend].self, forKey: .user)
    }
    
    self.attributes = try friendsContainer.decode(UUserTopItemsAttributes.self, forKey: .attributes)
  }
}

extension UUserFriends: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: MainKey.self)
    var friendsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .friends)
    
    try friendsContainer.encode(friends, forKey: .user)
    try friendsContainer.encode(attributes, forKey: .attributes)
  }
}
