//
//  UmeroKit+Scrobbling.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

struct NowPlayingPostData: Codable {
  var method: String
  var track: String
  var artist: String
  var api_sig: String
  var api_key: String
  var sk: String
}

// MARK: - Scrobbling & Authentication
extension UmeroKit {
  public func updateNowPlaying(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .updateNowPlaying,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func scrobble(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .scrobble,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func love(track: String, artist: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    let request = ULoveRequest(
      track: track,
      artist: artist,
      apiKey: apiKey,
      sessionKey: authResponse.key,
      secret: secret
    )
    _ = try await request.response()
  }

  public func checkLogin(username: String, password: String) async throws {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }

    let authRequest = UAuthDataRequest(
      username: username,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    _ = try await authRequest.response()
  }
}
