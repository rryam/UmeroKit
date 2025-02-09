//
//  UAuthDataRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 08/03/23.
//

import Foundation
import CryptoKit

struct UAuthDataRequest {
  private var username: String

  private var password: String

  private var apiKey: String

  private var secret: String

  init(username: String, password: String, apiKey: String, secret: String) {
    self.username = username
    self.password = password
    self.apiKey = apiKey
    self.secret = secret
  }

  func response() async throws -> USession.Session {
    let endpoint = AuthEndpoint.getMobileSession
    var components = UURLComponents(apiKey: self.apiKey, endpoint: endpoint)
    var signature = ""

    var signatureParameters = [
      "method": endpoint.path,
      "api_key": apiKey,
      "password": password,
      "username": username
    ]

    for key in signatureParameters.keys.sorted() {
      signature += "\(key)\(signatureParameters[key]!)"
    }

    signature += secret

    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

    let parameters = [
      "username": username,
      "password": password,
      "api_sig": hashedSignature]

    components.items = parameters.map { URLQueryItem(name: $0, value: $1) }

    let request = UDataPostRequest<USession>(url: components.url)
    let response = try await request.response()
      
    // Check if both error and message are present
    if let errorCode = response.error, let errorMessage = response.message {
        throw NSError(domain: "UmeroKit", code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
      
    return response.session
  }
}
