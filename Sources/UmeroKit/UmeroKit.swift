//
//  UmeroKit.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation
import CryptoKit

struct UItemCollection: Codable {
  let album: UAlbum
}

public struct UmeroKit: Sendable {
  let apiKey: String
  let secret: String
  let username: String?
  let password: String?
  let sessionKeyStore: USessionKeyStore

  public init(apiKey: String, secret: String, username: String? = nil, password: String? = nil) {
    self.apiKey = apiKey
    self.secret = secret
    self.username = username
    self.password = password
    self.sessionKeyStore = USessionKeyStore()
  }
}

actor USessionKeyStore {
  private var sessionKey: String?

  func value() -> String? {
    sessionKey
  }

  func store(_ sessionKey: String) {
    self.sessionKey = sessionKey
  }
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
