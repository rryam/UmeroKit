//
//  ChartEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with chart data from the Last.fm API.
enum ChartEndpoint: String, UURLEndpoint {
  case getTopArtists
  case getTopTracks
  case getTopTags

  var path: String {
    "chart." + rawValue.lowercased()
  }
}
