//
//  ArtistEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

enum ArtistEndpoint: String, URLEndpoint {
  case getInfo
  case getTags
  case getTopTags
  case getTopAlbums
  case getTopTracks
  case search
  case getSimilar

  var name: String {
    "artist." + rawValue.lowercased()
  }
}
