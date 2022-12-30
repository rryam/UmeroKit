//
//  GeoEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with geographical data from the Last.fm API.
enum GeoEndpoint: String, URLEndpoint {
  case getTopArtists
  case getTopTracks

  var name: String {
    "geo." + rawValue.lowercased()
  }
}
