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

  init(username: String, password: String, key: String) {
    self.username = username
    self.password = password
    self.key = key
  }

  func response() async throws {
    var components = UURLComponents(apiKey: key, endpoint: AuthEndpoint.getMobileSession)

    let signature = "api_key\(key)method\(AuthEndpoint.getMobileSession.path)password\(password)username\(username)"
    let data = Data(signature.utf8)
    let hashedSignature = Insecure.MD5.hash(data: data)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "username", value: username))
    queryItems.append(URLQueryItem(name: "password", value: password))
    queryItems.append(URLQueryItem(name: "api_sig", value: "\(hashedSignature)"))

    components.items = queryItems

    guard let url = components.url else {
      throw URLError(.badURL)
    }

    let request = UDataPostRequest(url: url)
    let response = try await request.response()

    print(try response.0.printJSON())
  }
}

extension Data {
  func printJSON() throws -> String {
    let json = try JSONSerialization.jsonObject(with: self, options: [])
    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

    guard let jsonString = String(data: data, encoding: .utf8) else {
      throw URLError(.cannotDecodeRawData)
    }
    return jsonString
  }
}
