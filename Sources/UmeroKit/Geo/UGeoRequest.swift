//
//  UGeoRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a request to fetch most popular artist and tracks by a country from Last.fm.
/// It is a generic struct that takes a type conforming to the `UGeoRequestable` and `Codable` protocols.
struct UGeoRequest<UGeoItemType> where UGeoItemType: UGeoRequestable, UGeoItemType: Codable {

  /// A country name, as defined by the ISO 3166-1 country names standard
  var country: String

  /// A limit for the number of results to fetch per page.
  /// Defaults to 50.
  var limit: Int

  /// The page number to fetch.
  /// Defaults to first page.
  var page: Int

  /// The geo chart endpoint to which the request will be sent.
  private var endpoint: GeoEndpoint

  /// Initializes a new `UGeoRequest` object with the specified country, endpoint, limit, and page.
  init(for country: String, endpoint: GeoEndpoint, limit: Int = 50, page: Int = 1) {
    self.country = country
    self.endpoint = endpoint
    self.limit = limit
    self.page = page
  }

  /// Makes a request to fetch country wise popular data using the specified API key.
  /// Returns the data as a `UGeoItemType` object conforming to the `UGeoRequestable` and `Codable` protocols.
  func response(with key: String) async throws -> UGeoItemType {
    var components = UURLComponents(apiKey: key, endpoint: endpoint)
    var queryItems: [URLQueryItem] = []

    queryItems.append(URLQueryItem(name: "country", value: country))
    queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
    queryItems.append(URLQueryItem(name: "page", value: "\(page)"))

    components.items = queryItems

    let request = UDataRequest<UGeoItemType>(url: components.url)
    let model = try await request.response()
    return model
  }
}
