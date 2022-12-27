//
//  TrackEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

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
