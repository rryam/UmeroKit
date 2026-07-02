//
//  UFormURLEncoder.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 02/07/26.
//

import Foundation

enum UFormURLEncoder {
  private static let allowedCharacters: CharacterSet = {
    var characters = CharacterSet.urlQueryAllowed
    characters.remove(charactersIn: "&+=")
    return characters
  }()

  static func formData(from parameters: [String: String]) throws -> Data {
    let bodyString = parameters
      .sorted(by: { $0.key < $1.key })
      .map { key, value in
        "\(encode(key))=\(encode(value))"
      }
      .joined(separator: "&")

    guard let data = bodyString.data(using: .utf8) else {
      throw UmeroKitError.invalidDataFormat("Could not encode POST body")
    }

    return data
  }

  private static func encode(_ value: String) -> String {
    value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? value
  }
}
