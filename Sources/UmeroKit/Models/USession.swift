//
//  USession.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 19/03/23.
//

import Foundation

struct USession: Codable {
  let session: Session
  let error: Int?
  let message: String?

  struct Session: Codable {
    let name: String
    let key: String
    let subscriber: Int
  }

  enum CodingKeys: String, CodingKey {
    case session
    case error
    case message
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let defaultSession = Session(name: "", key: "", subscriber: 0)

    self.session = try container.decodeIfPresent(Session.self, forKey: .session)
      ?? defaultSession
    self.error = try container.decodeIfPresent(Int.self, forKey: .error)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
}
