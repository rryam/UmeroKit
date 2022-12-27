//
//  ChartEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

enum ChartEndpoint: String, URLEndpoint {
  case getTopArtists
  case getTopTracks
  case getTopTags

  var name: String {
    "chart." + rawValue.lowercased()
  }
}
