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
    let components = UURLPostComponents()
    var signature = ""

    var parameters: [String: String] = [
      "method": endpoint.path,
      "api_key": apiKey,
      "password": password,
      "username": username
    ]

    for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
      signature += "\(key)\(value)"
    }

    signature += secret

    let hashedSignature = MD5Helper.hash(signature)

    parameters["api_sig"] = hashedSignature

    // Use URLComponents to properly encode form values, escaping reserved characters
    var urlComponents = URLComponents()
    urlComponents.queryItems = parameters.sorted(by: { $0.key < $1.key }).map { key, value in
      URLQueryItem(name: key, value: value)
    }
    
    // Get the query string (without the leading ?)
    guard let queryString = urlComponents.url?.absoluteString.dropFirst() else {
      throw UmeroKitError.invalidURL
    }
    
    let postData = String(queryString).data(using: .utf8)

    let request = UDataPostRequest<USession>(url: components.url, data: postData)
    let response = try await request.response()

    // Check if both error and message are present
    if let errorCode = response.error, let errorMessage = response.message {
        throw UmeroKitError.authenticationFailed(code: errorCode, message: errorMessage)
    }
    
    // Validate session key is present and not empty
    guard !response.session.key.isEmpty else {
        throw UmeroKitError.authenticationFailed(
            code: response.error ?? -1,
            message: response.message ?? "Authentication failed: Session key is missing"
        )
    }

    return response.session
  }
}
