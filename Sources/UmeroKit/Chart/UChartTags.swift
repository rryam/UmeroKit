//
//  UChartTags.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

public struct UChartTags: Codable {
  public let tags: UTags
  public let attributes: UChartAttributes
}

extension UChartTags: UChartRequestable {
}
