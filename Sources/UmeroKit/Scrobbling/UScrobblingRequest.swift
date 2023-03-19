//
//  UScrobblingRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 20/03/23.
//

import Foundation
import CryptoKit

/// Represents a set of endpoints for interacting with scrobbling data from the Last.fm API.
enum ScrobblingEndpoint: String, UURLEndpoint {
  case updateNowPlaying
  case scrobble

  var path: String {
    "track." + rawValue.lowercased()
  }
}

struct UScrobblingRequest {
  private let track: String

  private let artist: String

  private let apiKey: String

  private let endpoint: ScrobblingEndpoint

  private let sessionKey: String

  private let secret: String

  init(track: String, artist: String, endpoint: ScrobblingEndpoint, apiKey: String, sessionKey: String, secret: String) {
    self.track = track
    self.artist = artist
    self.apiKey = apiKey
    self.endpoint = endpoint
    self.sessionKey = sessionKey
    self.secret = secret
  }

  func response() async throws {
    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    var signature = ""
    var postData: Data
    let timestamp = Date().timeIntervalSince1970

    switch endpoint {
      case .updateNowPlaying:
        signature = "api_key\(apiKey)artist\(artist)method\(endpoint.path)sk\(sessionKey)track\(track)\(secret)"
      case .scrobble:
        signature = "api_key\(apiKey)artist\(artist)method\(endpoint.path)sk\(sessionKey)timestamp\(timestamp)track\(track)\(secret)"
    }

    print(signature)
    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

    switch endpoint {
      case .updateNowPlaying:
      postData = "method=\(endpoint.path)&track=\(track)&artist=\(artist)&api_sig=\(hashedSignature)&api_key=\(apiKey)&sk=\(sessionKey)".data(using: .utf8)!
      case .scrobble:
        postData = "method=\(endpoint.path)&track=\(track)&artist=\(artist)&api_sig=\(hashedSignature)&api_key=\(apiKey)&sk=\(sessionKey)&timestamp=\(timestamp)".data(using: .utf8)!
    }

    let request = UDataPostRequest<UItemCollection>(url: components.url, data: postData)
    let response = try await request.responseData()
    print(try response.printJSON())

  }
}
