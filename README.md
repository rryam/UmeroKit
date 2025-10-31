# UmeroKit

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)](https://github.com/rryam/UmeroKit)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

A modern, thread-safe Swift library for integrating Last.fm API into your apps.

<p align="center">
  <img src="https://github.com/rryam/UmeroKit/blob/main/UmeroKit.png" alt="UmeroKit Logo" width="256"/>
</p>

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Examples](#examples)
  - [Get Top Charts](#get-top-charts)
  - [Search by Country](#search-by-country)
  - [Album Information](#album-information)
  - [Artist Information](#artist-information)
  - [Track Information](#track-information)
  - [Scrobbling](#scrobbling)
  - [Tag Exploration](#tag-exploration)
  - [User Information](#user-information)
- [Error Handling](#error-handling)
- [Advanced Usage](#advanced-usage)
  - [Multiple Instances](#multiple-instances)
  - [Background Processing](#background-processing)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Scrobbling** - Update now playing and scrobble tracks
- **Love tracks** - Mark tracks as loved
- **Charts** - Access top artists, tracks, and tags
- **Geo data** - Get popular music by country
- **Tags** - Explore music by tags
- **User data** - Access user-specific information
- **Thread-safe** - Safe for concurrent use
- **Multi-platform** - iOS, macOS, tvOS, watchOS

## Requirements

- iOS 13.0+ / macOS 11.0+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.0+
- Last.fm API key

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rryam/UmeroKit.git", from: "1.0.0")
]
```

Or in Xcode, go to File → Add Packages and enter the repository URL.

## Quick Start

First, get your Last.fm API key from [last.fm/api](https://www.last.fm/api).

Then create a UmeroKit instance with your credentials:

```swift
import UmeroKit

// Create instance with your API credentials
let umero = UmeroKit(
    apiKey: "YOUR_API_KEY",
    secret: "YOUR_API_SECRET",
    username: "YOUR_USERNAME",    // Optional: for scrobbling
    password: "YOUR_PASSWORD"     // Optional: for scrobbling
)
```

## Examples

### Get Top Charts

```swift
// Top artists worldwide
let topArtists = try await umero.topChartArtists(limit: 10)
print("Top artist: \(topArtists.artists.first?.name ?? "None")")

// Top tracks globally
let topTracks = try await umero.topChartTracks(limit: 20)

// Popular tags
let topTags = try await umero.topChartTags()
```

### Search by Country

```swift
// Get popular artists in India
let indianArtists = try await umero.topArtists(for: "India", limit: 10)

// Popular tracks in the UK
let ukTracks = try await umero.topTracks(for: "United Kingdom")
```

### Album Information

```swift
// Get album details by name
let album = try await umero.albumInfo(for: "Random Access Memories", artist: "Daft Punk")
print("Album: \(album.name), Playcount: \(album.playcount ?? 0)")

// Get album by MusicBrainz ID
let albumByMBID = try await umero.albumInfo(for: UItemID(rawValue: "some-mbid"))

// Search for albums
let searchResults = try await umero.searchAlbum(album: "Dark Side", limit: 10)
print("Found \(searchResults.attributes.totalResults) albums")
for album in searchResults.albums.album {
    print("- \(album.name) by \(album.artist)")
}

// Get tags applied by a user to an album
let albumTags = try await umero.albumTags(for: "OK Computer", artist: "Radiohead", username: "rj")

// Get top tags for an album
let topTags = try await umero.albumTopTags(for: "In a Silent Way", artist: "Miles Davis")
```

### Artist Information

```swift
// Get artist details
let artist = try await umero.artistInfo(for: "Radiohead")
print("Artist: \(artist.name), Listeners: \(artist.stats?.listeners ?? 0)")

// Search for artists
let searchResults = try await umero.searchArtist(artist: "Radio", limit: 10)
print("Found \(searchResults.attributes.totalResults) artists")
for artist in searchResults.artists.artist {
    print("- \(artist.name)")
}

// Get top albums for an artist
let topAlbums = try await umero.artistTopAlbums(for: "Radiohead", limit: 10)

// Get top tracks for an artist
let topTracks = try await umero.artistTopTracks(for: "Radiohead", limit: 10)

// Get similar artists
let similarArtists = try await umero.similarArtists(for: "Radiohead", limit: 10)

// Get tags applied by a user to an artist
let artistTags = try await umero.artistTags(for: "Radiohead", username: "rj")

// Get top tags for an artist
let topTags = try await umero.artistTopTags(for: "Radiohead")
```

### Track Information

```swift
// Search for tracks
let searchResults = try await umero.searchTrack(track: "Bohemian", artist: "Queen", limit: 10)
print("Found \(searchResults.attributes.totalResults) tracks")
for track in searchResults.tracks.track {
    print("- \(track.name) by \(track.artist)")
}

// Get track details
let track = try await umero.trackInfo(for: "Bohemian Rhapsody", artist: "Queen")
print("Track: \(track.name), Playcount: \(track.playcount ?? 0)")

// Get tags applied by a user to a track
let trackTags = try await umero.trackTags(for: "Bohemian Rhapsody", artist: "Queen", username: "rj")

// Get top tags for a track
let topTags = try await umero.trackTopTags(for: "Bohemian Rhapsody", artist: "Queen")

// Get similar tracks
let similarTracks = try await umero.similarTracks(for: "Bohemian Rhapsody", artist: "Queen", limit: 10)
```

### Scrobbling

```swift
// Update now playing
try await umero.updateNowPlaying(track: "Karma Police", artist: "Radiohead")

// Scrobble a track
try await umero.scrobble(track: "Exit Music (For a Film)", artist: "Radiohead")

// Love a track
try await umero.love(track: "Creep", artist: "Radiohead")
```

### Tag Exploration

```swift
// Get top tags
let tags = try await umero.topTags()

// Get tag information
let rockTag = try await umero.tagInfo(for: "rock")
print("Rock tag has \(rockTag.total) items")

// Get top artists for a tag
let tagArtists = try await umero.tagTopArtists(for: "rock", limit: 10)

// Get top albums for a tag
let tagAlbums = try await umero.tagTopAlbums(for: "rock", limit: 10)

// Get top tracks for a tag
let tagTracks = try await umero.tagTopTracks(for: "rock", limit: 10)

// Get similar tags
let similarTags = try await umero.similarTags(for: "rock")

// Get weekly chart list for a tag
let weeklyChartList = try await umero.tagWeeklyChartList(for: "rock")

// Get album tags
let albumTags = try await umero.albumTopTags(for: "In a Silent Way", artist: "Miles Davis")
```

### User Information

```swift
// Note: User methods require authentication (username and password)

// Get user profile information
let userInfo = try await umero.userInfo()
print("User: \(userInfo.name), Playcount: \(userInfo.playcount ?? 0)")

// Get user's tags
let userTags = try await umero.userTags()

// Get user's top tags
let topTags = try await umero.userTopTags(limit: 10)

// Get user's top artists (with period support)
let topArtists = try await umero.userTopArtists(period: "7day", limit: 10)
let overallArtists = try await umero.userTopArtists(period: "overall")

// Get user's top albums
let topAlbums = try await umero.userTopAlbums(period: "1month", limit: 10)

// Get user's top tracks
let topTracks = try await umero.userTopTracks(period: "12month", limit: 10)

// Get user's recent tracks
let recentTracks = try await umero.userRecentTracks(limit: 10, extended: true)

// Get user's loved tracks
let lovedTracks = try await umero.userLovedTracks(limit: 20)

// Get user's friends
let friends = try await umero.userFriends(limit: 10)

// Get user's weekly chart list
let chartList = try await umero.userWeeklyChartList()

// Get weekly album chart
let weeklyAlbums = try await umero.userWeeklyAlbumChart(
    from: 1234567890,
    to: 1235174400
)

// Get weekly artist chart
let weeklyArtists = try await umero.userWeeklyArtistChart(
    from: 1234567890,
    to: 1235174400
)

// Get weekly track chart
let weeklyTracks = try await umero.userWeeklyTrackChart(
    from: 1234567890,
    to: 1235174400
)

// Get personal tags
let personalTags = try await umero.userPersonalTags(
    tag: "rock",
    taggingtype: "artist",
    limit: 10
)
```

## Error Handling

UmeroKit throws `UmeroKitError` for various failure conditions:

```swift
do {
    let artist = try await umero.artistInfo(for: "Unknown Artist")
} catch UmeroKitError.missingAPIKey {
    print("API key not configured")
} catch UmeroKitError.missingSecret {
    print("API secret not configured")
} catch {
    print("Other error: \(error)")
}
```

## Advanced Usage

### Multiple Instances

Create separate instances for different users or API keys:

```swift
let user1Client = UmeroKit(apiKey: "key1", secret: "secret1", username: "user1", password: "pass1")
let user2Client = UmeroKit(apiKey: "key2", secret: "secret2", username: "user2", password: "pass2")

// Use different instances for different operations
let user1Tracks = try await user1Client.topChartTracks()
let user2Tracks = try await user2Client.topChartTracks()
```

### Background Processing

Since UmeroKit is thread-safe, you can use it in background tasks:

```swift
Task.detached {
    do {
        let tracks = try await umero.topChartTracks()
        await MainActor.run {
            // Update UI on main thread
            self.displayTracks(tracks.tracks)
        }
    } catch {
        print("Failed to fetch tracks: \(error)")
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
