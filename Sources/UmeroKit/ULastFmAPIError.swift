//
//  ULastFmAPIError.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 02/07/26.
//

import Foundation

enum ULastFmAPIError {
  private struct Response: Decodable {
    let error: Int?
    let message: String?
  }

  static func throwIfPresent(in data: Data) throws {
    guard
      let response = try? JSONDecoder().decode(Response.self, from: data),
      let code = response.error,
      let message = response.message
    else {
      return
    }

    throw UmeroKitError.apiError(code: code, message: message)
  }
}

extension UmeroKitError {
  var isInvalidSessionKey: Bool {
    guard case .apiError(let code, _) = self else {
      return false
    }

    return code == 9
  }
}
