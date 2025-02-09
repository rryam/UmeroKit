//
//  UDataRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

struct UDataRequest<Model: Codable> {
  private var url: URL?

  init(url: URL?) {
    self.url = url
  }

  func response() async throws -> Model {
    guard let url else {
      throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let model = try decoder.decode(Model.self, from: data)
    return model
  }
}

public struct UDataPostRequest<Model: Codable>: Sendable {
  /// The URL for the data request.
  var url: URL?
  var data: Data?


  init(url: URL?, data: Data? = nil) {
    self.url = url
    self.data = data
  }

  /// Write data to the last.fm endpoint that
  /// the URL request defines.
  public func response() async throws -> Model {
    guard let url else {
      throw URLError(.badURL)
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = data

    let (urlRequestData, _) = try await URLSession.shared.data(for: urlRequest)

    print(try urlRequestData.printJSON())

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let model = try decoder.decode(Model.self, from: urlRequestData)

    return model
  }

  public func responseData() async throws -> Data {
    guard let url else {
      throw URLError(.badURL)
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = data
    let (urlRequestData, _) = try await URLSession.shared.data(for: urlRequest)
    return urlRequestData
  }
}
