//
//  UChartRequestable.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Defines the property that an object must implement in order to request data for a chart.
protocol UChartRequestable {

  /// The attributes of the chart.
  var attributes: UChartAttributes { get }
}
