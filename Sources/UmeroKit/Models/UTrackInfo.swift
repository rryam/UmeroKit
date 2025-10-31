//
//  UTrackInfo.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

struct UTrackInfo: Codable {
  let track: UTrack
}

extension UTrackInfo {
  enum CodingKeys: String, CodingKey {
    case track
  }
  
  // Custom decoder to handle track.getInfo response structure
  // where image is nested under album.image instead of at track level
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // Decode into an intermediate structure that matches the API response
    let trackResponse = try container.decode(TrackResponse.self, forKey: .track)
    
    // Extract image from album.image if present, otherwise use empty array
    let image = trackResponse.album?.image ?? []
    
    // Parse numeric values
    var duration: Int = 0
    if let durationString = trackResponse.duration, !durationString.isEmpty {
      guard let durationValue = Int(durationString) else {
        throw UmeroKitError.invalidDataFormat("Duration is not a valid number for track '\(trackResponse.name)'")
      }
      duration = durationValue
    }
    
    var playcount: Double = 0
    if let playcountString = trackResponse.playcount, !playcountString.isEmpty {
      guard let playcountValue = Double(playcountString) else {
        throw UmeroKitError.invalidDataFormat("Playcount is not a valid number for track '\(trackResponse.name)'")
      }
      playcount = playcountValue
    }
    
    var listeners: Double = 0
    if let listenersString = trackResponse.listeners, !listenersString.isEmpty {
      guard let listenersValue = Double(listenersString) else {
        throw UmeroKitError.invalidDataFormat("Listeners is not a valid number for track '\(trackResponse.name)'")
      }
      listeners = listenersValue
    }
    
    // Create UTrack using the synthesized memberwise initializer
    // Note: This works because UTrack is a struct and Swift synthesizes the initializer
    self.track = UTrack(
      name: trackResponse.name,
      duration: duration,
      playcount: playcount,
      listeners: listeners,
      mbid: trackResponse.mbid.map { UItemID(rawValue: $0) },
      url: trackResponse.url,
      artist: trackResponse.artist,
      image: image
    )
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(track, forKey: .track)
  }
}

// Intermediate struct matching the API response structure
private struct TrackResponse: Decodable {
  let name: String
  let mbid: String?
  let url: URL
  let duration: String?
  let playcount: String?
  let listeners: String?
  let artist: UArtist
  let album: AlbumResponse?
  
  enum CodingKeys: String, CodingKey {
    case name, mbid, url, duration, playcount, listeners, artist, album
  }
}

private struct AlbumResponse: Decodable {
  let image: [UImage]
  
  enum CodingKeys: String, CodingKey {
    case image
  }
}
