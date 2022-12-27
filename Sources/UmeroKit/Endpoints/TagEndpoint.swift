//
//  TagEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

enum TagEndpoint: String, URLEndpoint {
  case getInfo
  case getTopArtists
  case getTopAlbums
  case getTopTracks
  case getTopTags
  case getSimilar
  case getWeeklyChartList

  var name: String {
    "tag." + rawValue.lowercased()
  }
}
