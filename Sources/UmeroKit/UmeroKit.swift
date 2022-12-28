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

  public func albumTopTags(for album: String,
                           artist: String,
                           autocorrect: Bool = false,
                           username: String? = nil,
                           language: String? = nil) async throws -> UTopTags {
    var components = UURLComponents(apiKey: apiKey, path: AlbumEndpoint.getTopTags)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "album", value: album))
    queryItems.append(URLQueryItem(name: "artist", value: artist))
    queryItems.append(URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)"))

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    return try await response(model: UTopTags.self, url: components.url)
  }
}

// MARK: - ARTIST
extension UmeroKit {
  public func artistInfo(for artist: String,
                         autocorrect: Bool = true,
                         username: String? = nil,
                         language: String? = nil) async throws -> UArtist {

    var components = UURLComponents(apiKey: apiKey, path: ArtistEndpoint.getInfo)

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "artist", value: artist))
    queryItems.append(URLQueryItem(name: "autocorrect", value: "\(autocorrect.intValue)"))

    if let username {
      queryItems.append(URLQueryItem(name: "username", value: username))
    }

    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }

    components.items = queryItems

    return try await response(model: UArtist.self, url: components.url)
  }
}

// MARK: - TAG
extension UmeroKit {
  public func tagInfo(for tag: String,
                      language: String? = nil) async throws -> UTag {
    var components = UURLComponents(apiKey: apiKey, path: TagEndpoint.getInfo)
    
    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "tag", value: tag))
    
    if let language {
      queryItems.append(URLQueryItem(name: "language", value: language))
    }
    
    components.items = queryItems
    
    let info = try await response(model: UTagInfo.self, url: components.url)
    return info.tag
  }
  
  public func topTags() async throws -> [UTag] {
    let components = UURLComponents(apiKey: apiKey, path: TagEndpoint.getTopTags)
    let model = try await response(model: UTopTags.self, url: components.url)
    return model.toptags.tag
  }
}

extension Bool {
  var intValue: Int {
    return self ? 1 : 0
  }
}
