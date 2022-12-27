//
//  AlbumEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

enum AlbumEndpoint: String, URLEndpoint {
  case getInfo
  case getTags
  case getTopTags
  case search

  var name: String {
    "album." + rawValue.lowercased()
  }
}
