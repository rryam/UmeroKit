//
//  TagEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with tag data from the Last.fm API.
enum TagEndpoint: String, UURLEndpoint {
  case getInfo
  case getTopArtists
  case getTopAlbums
  case getTopTracks
  case getTopTags
  case getSimilar
  case getWeeklyChartList

  var path: String {
    "tag." + rawValue.lowercased()
  }
}
