# UmeroKit

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)](https://github.com/rryam/UmeroKit)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![License](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

A modern, thread-safe Swift library for integrating Last.fm API into your apps.

<p align="center">
  <img src="https://github.com/rryam/UmeroKit/blob/main/UmeroKit.png" alt="UmeroKit Logo" width="256"/>
</p>

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
    .package(url: "https://github.com/rryam/UmeroKit.git", from: "1.1.0")
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
```

### Artist Information

```swift
// Get artist details
let artist = try await umero.artistInfo(for: "Radiohead")
print("Artist: \(artist.name), Listeners: \(artist.stats?.listeners ?? 0)")
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

// Get album tags
let albumTags = try await umero.albumTopTags(for: "In a Silent Way", artist: "Miles Davis")
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
