//
//  ArtistEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with artist data from the Last.fm API.
enum ArtistEndpoint: String, UURLEndpoint {
  case getInfo
  case getTags
  case getTopTags
  case getTopAlbums
  case getTopTracks
  case search
  case getSimilar

  var path: String {
    "artist." + rawValue.lowercased()
  }
}
