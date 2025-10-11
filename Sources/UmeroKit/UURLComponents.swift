//
//  UURLComponents.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

struct UURLPostComponents {
  private var components: URLComponents

  public init() {
    self.components = URLComponents()
    components.scheme = "https"
    components.host = "ws.audioscrobbler.com"
    components.path = "/2.0"
    components.queryItems = [URLQueryItem(name: "format", value: "json")]
  }

  public var url: URL? {
    components.url
  }
}

struct UURLComponents {
  private var components: URLComponents
  private var queryItems: [URLQueryItem]

  public init(apiKey: String, endpoint: UURLEndpoint) {
    self.components = URLComponents()
    components.scheme = "https"
    components.host = "ws.audioscrobbler.com"
    components.path = "/2.0"

    let key = URLQueryItem(name: "api_key", value: apiKey)
    let format = URLQueryItem(name: "format", value: "json")
    let path = URLQueryItem(name: "method", value: endpoint.path)

    self.queryItems = [path, key, format]
    components.queryItems = queryItems
  }

  public var items: [URLQueryItem]? {
    get {
      components.queryItems
    } set {
      if let newValue {
        components.queryItems = queryItems + newValue
      } else {
        components.queryItems = queryItems
      }
    }
  }

  public var url: URL? {
    components.url
  }
}
