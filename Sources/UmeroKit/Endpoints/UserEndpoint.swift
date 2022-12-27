//
//  UserEndpoint.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

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
