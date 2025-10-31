//
//  UmeroKit+User.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

// MARK: - User
extension UmeroKit {
  /// Helper function to fetch user data from Last.fm API endpoints.
  ///
  /// - Parameters:
  ///   - endpoint: The user endpoint to call.
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of items to retrieve (optional).
  ///   - page: The page of results to retrieve (optional).
  ///   - period: The time period for top items (optional).
  ///   - from: The start date/timestamp (optional).
  ///   - to: The end date/timestamp (optional).
  ///   - extended: Whether to return extended information (optional).
  ///   - taggingtype: The type of tags to retrieve (optional).
  ///   - tag: The tag name for personal tags (optional).
  /// - Returns: The decoded response model of type `T`.
  private func getUserData<T: Decodable>(
    _ endpoint: UserEndpoint,
    username: String? = nil,
    limit: Int? = nil,
    page: Int? = nil,
    period: String? = nil,
    from: Int? = nil,
    to: Int? = nil,
    extended: Bool? = nil,
    taggingtype: String? = nil,
    tag: String? = nil
  ) async throws -> T {
    guard !apiKey.isEmpty else { throw UmeroKitError.missingAPIKey }
    guard !secret.isEmpty else { throw UmeroKitError.missingSecret }
    guard let instanceUsername = self.username else { throw UmeroKitError.missingUsername }
    guard let password else { throw UmeroKitError.missingPassword }

    // Authenticate to get session key
    let authRequest = UAuthDataRequest(
      username: instanceUsername,
      password: password,
      apiKey: apiKey,
      secret: secret
    )
    let authResponse = try await authRequest.response()

    var components = UURLComponents(apiKey: apiKey, endpoint: endpoint)
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "sk", value: authResponse.key)
    ]

    // Add username parameter if provided (for querying other users)
    // If not provided, use the authenticated user's username
    let targetUsername = username ?? instanceUsername
    queryItems.append(URLQueryItem(name: "user", value: targetUsername))

    // Helper function to conditionally add query items
    func addQueryItemIfPresent(_ name: String, value: String?) {
      if let value {
        queryItems.append(URLQueryItem(name: name, value: value))
      }
    }

    addQueryItemIfPresent("limit", value: limit.map { String($0) })
    addQueryItemIfPresent("page", value: page.map { String($0) })
    addQueryItemIfPresent("period", value: period)
    addQueryItemIfPresent("from", value: from.map { String($0) })
    addQueryItemIfPresent("to", value: to.map { String($0) })
    
    if let extended {
      queryItems.append(URLQueryItem(name: "extended", value: "\(extended.intValue)"))
    }
    
    addQueryItemIfPresent("taggingtype", value: taggingtype)
    addQueryItemIfPresent("tag", value: tag)

    components.items = queryItems

    let request = UDataRequest<T>(url: components.url)
    return try await request.response()
  }

  /// Get user profile information.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let userInfo = try await umero.userInfo()
  ///  } catch {
  ///    print("Error fetching user info: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username to get info for (optional, defaults to authenticated user).
  /// - Returns: A `UUserInfo` object containing the user's profile information.
  public func userInfo(for username: String? = nil) async throws -> UUserInfo {
    try await getUserData(.getInfo, username: username)
  }

  /// Get tags applied by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userTags(for: "someuser")
  ///  } catch {
  ///    print("Error fetching user tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username whose tags you want to retrieve (optional, defaults to authenticated user).
  /// - Returns: An array of `UTag` objects representing the tags.
  public func userTags(for username: String? = nil) async throws -> [UTag] {
    let response: UUserTags = try await getUserData(.getTags, username: username)
    return response.tags.tag
  }

  /// Get the top tags for a user on Last.fm, ordered by popularity.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userTopTags(for: "someuser")
  ///  } catch {
  ///    print("Error fetching top tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tags to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopTags` object containing the top tags.
  public func userTopTags(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopTags {
    try await getUserData(.getTopTags, username: username, limit: limit, page: page)
  }

  /// Get the top artists for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let artists = try await umero.userTopArtists(for: "someuser", period: "overall")
  ///  } catch {
  ///    print("Error fetching top artists: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of artists to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopArtists` object containing the top artists for the user.
  public func userTopArtists(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopArtists {
    try await getUserData(.getTopArtists, username: username, limit: limit, page: page, period: period)
  }

  /// Get the top albums for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let albums = try await umero.userTopAlbums(for: "someuser", period: "7day")
  ///  } catch {
  ///    print("Error fetching top albums: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of albums to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopAlbums` object containing the top albums for the user.
  public func userTopAlbums(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopAlbums {
    try await getUserData(.getTopAlbums, username: username, limit: limit, page: page, period: period)
  }

  /// Get the top tracks for a user on Last.fm.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userTopTracks(for: "someuser", period: "1month")
  ///  } catch {
  ///    print("Error fetching top tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - period: The time period (overall, 7day, 1month, 3month, 6month, 12month). Default: overall.
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserTopTracks` object containing the top tracks for the user.
  public func userTopTracks(
    for username: String? = nil,
    period: String = "overall",
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserTopTracks {
    try await getUserData(.getTopTracks, username: username, limit: limit, page: page, period: period)
  }

  /// Get recent tracks scrobbled by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userRecentTracks(for: "someuser", limit: 10)
  ///  } catch {
  ///    print("Error fetching recent tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  ///   - from: The start timestamp (optional).
  ///   - to: The end timestamp (optional).
  ///   - extended: Whether to return extended information (default: false).
  /// - Returns: A `UUserRecentTracks` object containing the recent tracks.
  public func userRecentTracks(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1,
    from: Int? = nil,
    to: Int? = nil,
    extended: Bool = false
  ) async throws -> UUserRecentTracks {
    try await getUserData(
      .getRecentTracks,
      username: username,
      limit: limit,
      page: page,
      from: from,
      to: to,
      extended: extended
    )
  }

  /// Get loved tracks by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tracks = try await umero.userLovedTracks(for: "someuser")
  ///  } catch {
  ///    print("Error fetching loved tracks: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of tracks to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserLovedTracks` object containing the loved tracks.
  public func userLovedTracks(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserLovedTracks {
    try await getUserData(.getLovedTracks, username: username, limit: limit, page: page)
  }

  /// Get the list of available weekly charts for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chartList = try await umero.userWeeklyChartList(for: "someuser")
  ///  } catch {
  ///    print("Error fetching weekly chart list: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameter username: The username (optional, defaults to authenticated user).
  /// - Returns: A `UUserWeeklyChartList` object containing the list of available weekly charts.
  public func userWeeklyChartList(for username: String? = nil) async throws -> UUserWeeklyChartList {
    try await getUserData(.getWeeklyChartList, username: username)
  }

  /// Get a weekly album chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyAlbumChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly album chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyAlbumChart` object containing the weekly album chart.
  public func userWeeklyAlbumChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyAlbumChart {
    try await getUserData(.getWeeklyAlbumChart, username: username, from: from, to: to)
  }

  /// Get a weekly artist chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyArtistChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly artist chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyArtistChart` object containing the weekly artist chart.
  public func userWeeklyArtistChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyArtistChart {
    try await getUserData(.getWeeklyArtistChart, username: username, from: from, to: to)
  }

  /// Get a weekly track chart for a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let chart = try await umero.userWeeklyTrackChart(for: "someuser", from: fromTimestamp, to: toTimestamp)
  ///  } catch {
  ///    print("Error fetching weekly track chart: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - from: The start timestamp of the chart period.
  ///   - to: The end timestamp of the chart period.
  /// - Returns: A `UUserWeeklyTrackChart` object containing the weekly track chart.
  public func userWeeklyTrackChart(
    for username: String? = nil,
    from: Int,
    to: Int
  ) async throws -> UUserWeeklyTrackChart {
    try await getUserData(.getWeeklyTrackChart, username: username, from: from, to: to)
  }

  /// Get a user's friends.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let friends = try await umero.userFriends(for: "someuser")
  ///  } catch {
  ///    print("Error fetching friends: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - limit: The number of friends to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserFriends` object containing the user's friends.
  public func userFriends(
    for username: String? = nil,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserFriends {
    try await getUserData(.getFriends, username: username, limit: limit, page: page)
  }

  /// Get personal tags applied by a user.
  ///
  ///  Example:
  ///   ```swift
  ///  do  {
  ///    let umero = UmeroKit(apiKey: apiKey, secret: secret, username: "myusername", password: "mypassword")
  ///    let tags = try await umero.userPersonalTags(for: "someuser", tag: "rock", taggingtype: "artist")
  ///  } catch {
  ///    print("Error fetching personal tags: \(error).")
  ///  }
  ///  ```
  ///
  /// - Parameters:
  ///   - username: The username (optional, defaults to authenticated user).
  ///   - tag: The tag name to retrieve personal tags for.
  ///   - taggingtype: The type of tags to retrieve (artist, album, or track).
  ///   - limit: The number of tags to retrieve (default: 50).
  ///   - page: The page of results to retrieve (default: 1).
  /// - Returns: A `UUserPersonalTags` object containing the personal tags.
  public func userPersonalTags(
    for username: String? = nil,
    tag: String,
    taggingtype: String,
    limit: Int = 50,
    page: Int = 1
  ) async throws -> UUserPersonalTags {
    try await getUserData(
      .getPersonalTags,
      username: username,
      limit: limit,
      page: page,
      taggingtype: taggingtype,
      tag: tag
    )
  }
}
