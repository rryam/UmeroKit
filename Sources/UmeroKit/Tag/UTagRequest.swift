//
//  UTagRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a request to fetch data for a tag from Last.fm.
/// It is a generic struct that takes a type conforming to the `UTagRequestable` and `Codable` protocols.
struct UTagRequest<UTagItemType> where UTagItemType: UTagRequestable, UTagItemType: Codable {

  /// The tag name.
  var tag: String

  /// A limit for the number of results to fetch per page.
  /// Defaults to 50.
  var limit: Int

  /// The page number to fetch.
  /// Defaults to first page.
  var page: Int

  /// The tag endpoint to which the request will be sent.
  private var endpoint: TagEndpoint

  /// Initializes a new `UTagRequest` object with the specified tag, endpoint, limit, and page.
  init(for tag: String, endpoint: TagEndpoint, limit: Int = 50, page: Int = 1) {
    self.tag = tag
    self.endpoint = endpoint
    self.limit = limit
    self.page = page
  }

  /// Makes a request to fetch data for a tag using the specified API key.
  /// Returns the data as a `UTagItemType` object conforming to the `UTagRequestable` and `Codable` protocols.
  func response(with key: String) async throws -> UTagItemType {
    var components = UURLComponents(apiKey: key, endpoint: endpoint)
    var queryItems: [URLQueryItem] = []

    queryItems.append(URLQueryItem(name: "tag", value: tag))
    queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
    queryItems.append(URLQueryItem(name: "page", value: "\(page)"))

    components.items = queryItems

    let request = UDataRequest<UTagItemType>(url: components.url)
    let model = try await request.response()
    return model
  }
}
