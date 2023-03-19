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

  private var key: String

  private var secret: String

  init(username: String, password: String, key: String, secret: String) {
    self.username = username
    self.password = password
    self.key = key
    self.secret = secret
  }

  func response() async throws -> (String, USession) {
    let endpoint = AuthEndpoint.getMobileSession
    var components = UURLComponents(apiKey: key, endpoint: endpoint)

    let signature = "api_key\(key)method\(endpoint.path)password\(password)username\(username)\(secret)"
    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

    components.items = [
      URLQueryItem(name: "username", value: username),
      URLQueryItem(name: "password", value: password),
      URLQueryItem(name: "api_sig", value: hashedSignature)
    ]

    let request = UDataPostRequest<USession>(url: components.url)
    let response = try await request.response()

    return (hashedSignature, response)
  }
}
