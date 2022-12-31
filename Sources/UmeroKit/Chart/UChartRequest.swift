//
//  UChartRequest.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import MusicKit
import Foundation

struct UChartRequest<UChartItemType> where UChartItemType: UChartRequestable, UChartItemType: Codable {
  /// A limit for the number of results to fetch per page.
  /// Defaults to 50.
  var limit: Int

  /// The page number to fetch.
  /// Defaults to first page.
  var page: Int

  private var endpoint: ChartEndpoint

  init(for endpoint: ChartEndpoint, limit: Int = 50, page: Int = 1) {
    self.endpoint = endpoint
    self.limit = limit
    self.page = page
  }

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
