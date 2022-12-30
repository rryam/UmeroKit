//
//  UserEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Represents a set of endpoints for interacting with user data from the Last.fm API.
enum UserEndpoint: String, URLEndpoint {
  case getFriends
  case getPersonalTags
  case getRecentTracks
  case getInfo
  case getTags
  case getLovedTracks
  case getTopArtists
  case getTopAlbums
  case getTopTracks
  case getTopTags
  case getWeeklyAlbumChart
  case getWeeklyArtistChart
  case getWeeklyChartList
  case getWeeklyTrackChart

  var name: String {
    "user." + rawValue.lowercased()
  }
}
