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
    var postData: Data? = nil

    var parameters = [
      "method": endpoint,
      "api_key": apiKey,
      "artist": artist,
      "track": track,
      "sk": sessionKey
    ]

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
