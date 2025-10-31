//
//  UmeroKit+Scrobbling.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - Scrobbling & Authentication
extension UmeroKit {
  /// Helper method to get authenticated session key.
  /// Validates credentials and returns a session key for authenticated requests.
  internal func getAuthenticatedSessionKey() async throws -> String {
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
    return authResponse.key
  }

  public func updateNowPlaying(track: String, artist: String) async throws {
    let sessionKey = try await getAuthenticatedSessionKey()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .updateNowPlaying,
      apiKey: apiKey,
      sessionKey: sessionKey,
      secret: secret
    )
    _ = try await request.response()
  }

  public func scrobble(track: String, artist: String) async throws {
    let sessionKey = try await getAuthenticatedSessionKey()

    let request = UScrobblingRequest(
      track: track,
      artist: artist,
      endpoint: .scrobble,
      apiKey: apiKey,
      sessionKey: sessionKey,
      secret: secret
    )
    _ = try await request.response()
  }

  public func love(track: String, artist: String) async throws {
    let sessionKey = try await getAuthenticatedSessionKey()

    let request = ULoveRequest(
      track: track,
      artist: artist,
      apiKey: apiKey,
      sessionKey: sessionKey,
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
