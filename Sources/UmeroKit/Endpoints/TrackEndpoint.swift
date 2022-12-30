//
//  TrackEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with track data from the Last.fm API.
enum TrackEndpoint: String, URLEndpoint {
  case getInfo
  case getTags
  case getSimilar
  case getTopTags
  case search

  var name: String {
    "track." + rawValue.lowercased()
  }
}
