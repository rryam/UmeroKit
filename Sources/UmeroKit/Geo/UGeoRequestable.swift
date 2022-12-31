//
//  UGeoRequestable.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 31/12/22.
//

import Foundation

/// Defines the property that an object must implement in order to request data for a country chart.
protocol UGeoRequestable {

  /// The attributes of the geo chart.
  var attributes: UGeoAttributes { get }
}
