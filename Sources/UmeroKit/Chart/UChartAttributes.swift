//
//  UChartAttributes.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents the attributes of a chart.
public struct UChartAttributes: Codable {

  /// The current page of the chart.
  public let page: String

  /// The number of items per page of the chart.
  public let perPage: String

  /// The total number of pages for the chart.
  public let totalPages: String

  /// The total number of items for the chart.
  public let total: String
}
