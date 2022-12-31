//
//  UChartRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import MusicKit
import Foundation

/// Represents a request to fetch data for a chart from Last.fm.
/// It is a generic struct that takes a type conforming to the `UChartRequestable` and `Codable` protocols.
struct UChartRequest<UChartItemType> where UChartItemType: UChartRequestable, UChartItemType: Codable {

  /// A limit for the number of results to fetch per page.
  /// Defaults to 50.
  var limit: Int

  /// The page number to fetch.
  /// Defaults to first page.
  var page: Int

  /// The chart endpoint to which the request will be sent.
  private var endpoint: ChartEndpoint

  /// Initializes a new `UChartRequest` object with the specified endpoint, limit, and page.
  init(for endpoint: ChartEndpoint, limit: Int = 50, page: Int = 1) {
    self.endpoint = endpoint
    self.limit = limit
    self.page = page
  }

  /// Makes a request to fetch data for a chart using the specified API key.
  /// Returns the data as a `UChartItemType` object conforming to the `UChartRequestable` and `Codable` protocols.
  func response(with key: String) async throws -> UChartItemType {
    var components = UURLComponents(apiKey: key, path: endpoint)
    var queryItems: [URLQueryItem] = []

    queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
    queryItems.append(URLQueryItem(name: "page", value: "\(page)"))

    components.items = queryItems

    let request = UDataRequest<UChartItemType>(url: components.url)
    let model = try await request.response()
    return model
  }
}
