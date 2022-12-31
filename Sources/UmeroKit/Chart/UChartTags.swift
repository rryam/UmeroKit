//
//  UChartTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Represents a chart of top tags.
public struct UChartTags: Codable {
  /// Collection of `UTags` representing the top tags on the chart.
  public let tags: UTags

  /// The attributes of the chart like page, total pages, and total count.
  public let attributes: UChartAttributes
}

extension UChartTags: UChartRequestable {
}
