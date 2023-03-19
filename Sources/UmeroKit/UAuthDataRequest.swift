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
    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)

    let hashedPassword = Insecure.MD5.hash(data: Data(password.utf8))

    let signature = "api_key\(apiKey)method\(endpoint.path)password\(hashedPassword)username\(username)\(secret)"
    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

    let password = hashedPassword.map { String(format: "%02hhx", $0) }.joined()
    let parameters = ["username": username, "password": password, "api_sig": hashedSignature]

    components.items = parameters.map { URLQueryItem(name: $0, value: $1) }

    let request = UDataPostRequest<USession>(url: components.url)
    let response = try await request.response()

    return response.session
  }
}
