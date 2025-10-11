//
//  ULoveRequest.swift
//
//
//  Created by Hidde van der Ploeg on 01/03/2024.
//

import Foundation
import CryptoKit

struct ULoveRequest {
  private let track: String

  private let artist: String

  private let apiKey: String

  private let endpoint: String = "track.love"

  private let sessionKey: String

  private let secret: String

  init(track: String, artist: String, apiKey: String, sessionKey: String, secret: String) {
    self.track = track
    self.artist = artist
    self.apiKey = apiKey
    self.sessionKey = sessionKey
    self.secret = secret
  }

  func response() async throws {
    let components = UURLPostComponents()
    var signature = ""

    var parameters: [String: String] = [
      "method": endpoint,
      "api_key": apiKey,
      "artist": artist,
      "track": track,
      "sk": sessionKey
    ]

    for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
      signature += "\(key)\(value)"
    }

    signature += secret

    let hashedSignature = MD5Helper.hash(signature)

    parameters["api_sig"] = hashedSignature

    let bodyString = parameters
      .sorted(by: { $0.key < $1.key })
      .map { key, value -> String in
        let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
        return "\(key)=\(encodedValue)"
      }
      .joined(separator: "&")

    let postData = bodyString.data(using: .utf8)

    let request = UDataPostRequest<UItemCollection>(url: components.url, data: postData)
    _ = try await request.responseData()
  }
}
