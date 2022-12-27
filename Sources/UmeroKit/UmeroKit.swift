//
//  UmeroKit.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

public class UmeroKit {
  var apiKey: String

  struct UItemCollection: Codable {
    let album: UAlbum
  }

  public init(apiKey: String) {
    self.apiKey = apiKey
  }

  func response<Model: Codable>(model: Model.Type, url: URL?) async throws -> Model {
    guard let url else {
      throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let model = try decoder.decode(model.self, from: data)
    return model
  }
}

// MARK: - ALBUM
extension UmeroKit {
  public func albumInfo(for album: String,
                        artist: String,
                        autocorrect: Bool = false,
                        username: String? = nil,
                        language: String? = nil) async throws -> UAlbum {
    var components = UURLComponents(apiKey: apiKey, path: AlbumEndpoint.getInfo)
    components.items = [URLQueryItem(name: "album", value: album), URLQueryItem(name: "artist", value: artist)]

    let model = try await response(model: UItemCollection.self, url: components.url)
    return model.album
  }

  public func albumInfo(for mbid: UItemID,
                        autocorrect: Bool = false,
                        username: String? = nil,
                        language: String? = nil) async throws -> UAlbum {
    var components = UURLComponents(apiKey: apiKey, path: AlbumEndpoint.getInfo)
    components.items = [URLQueryItem(name: "mbid", value: mbid.rawValue)]

    let model = try await response(model: UItemCollection.self, url: components.url)
    return model.album
  }
}
