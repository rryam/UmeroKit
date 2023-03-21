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
    let components = UURLPostComponents()
    var signature = ""
    var postData: Data? = nil

    var parameters = [
      "method": endpoint.path,
      "api_key": apiKey,
      "artist": artist,
      "track": track,
      "sk": sessionKey
    ]

    switch endpoint {
      case .updateNowPlaying: ()
      case .scrobble:
        parameters["timestamp"] = String(Int(Date().timeIntervalSince1970))
    }

    for key in parameters.keys.sorted() {
      signature += "\(key)\(parameters[key]!)"
    }

    signature += secret

    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

    parameters["api_sig"] = hashedSignature

    postData = parameters.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }.joined(separator: "&").data(using: .utf8)

    let request = UDataPostRequest<UItemCollection>(url: components.url, data: postData)
    let response = try await request.responseData()
    print(try response.printJSON())
    
  }
}
