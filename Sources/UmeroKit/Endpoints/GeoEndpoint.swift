//
//  GeoEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with geographical data from the Last.fm API.
enum GeoEndpoint: String, UURLEndpoint {
  case getTopArtists
  case getTopTracks

  var path: String {
    "geo." + rawValue.lowercased()
  }
}
