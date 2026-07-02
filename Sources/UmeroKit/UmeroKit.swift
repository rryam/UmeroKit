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
  private var authTask: Task<String, Error>?

  func value(load: @Sendable @escaping () async throws -> String) async throws -> String {
    if let sessionKey {
      return sessionKey
    }

    if let authTask {
      return try await authTask.value
    }

    let task = Task {
      try await load()
    }
    authTask = task

    do {
      let sessionKey = try await task.value
      self.sessionKey = sessionKey
      authTask = nil
      return sessionKey
    } catch {
      authTask = nil
      throw error
    }
  }

  func clear() {
    sessionKey = nil
    authTask = nil
  }
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
