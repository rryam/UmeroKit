//
//  AlbumEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with album data from the Last.fm API.
enum AlbumEndpoint: String, UURLEndpoint {

  /// Get the metadata and tracklist for an album on Last.fm using the album name or a musicbrainz id.
  case getInfo

  /// Get the tags applied by an individual user to an album on Last.fm.
  case getTags

  /// Get the top tags for an album on Last.fm, ordered by popularity.
  case getTopTags

  /// Search for an album by name. Returns album matches sorted by relevance.
  case search

  var path: String {
    "album." + rawValue.lowercased()
  }
}
