//
//  GeoEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

enum GeoEndpoint: String, URLEndpoint {
  case getTopArtists
  case getTopTracks

  var name: String {
    "geo." + rawValue.lowercased()
  }
}
