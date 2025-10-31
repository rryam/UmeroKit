# Last.fm API Coverage Report

Generated: $(date)

This report analyzes the coverage of Last.fm API endpoints in UmeroKit, comparing defined endpoints with implemented methods.

## Summary

- **Total Endpoints Defined**: 48
- **Total Endpoints Implemented**: 19
- **Coverage**: 39.6%

## Endpoint Coverage by Category

### Album Endpoints (`album.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `album.getInfo` | ✅ | ✅ | **COMPLETE** |
| `album.getTags` | ✅ | ❌ | **MISSING** |
| `album.getTopTags` | ✅ | ✅ | **COMPLETE** |
| `album.search` | ✅ | ✅ | **COMPLETE** |

**Missing**: 1 endpoint (`album.getTags`)

### Artist Endpoints (`artist.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `artist.getInfo` | ✅ | ✅ | **COMPLETE** |
| `artist.getTags` | ✅ | ❌ | **MISSING** |
| `artist.getTopTags` | ✅ | ❌ | **MISSING** |
| `artist.getTopAlbums` | ✅ | ❌ | **MISSING** |
| `artist.getTopTracks` | ✅ | ❌ | **MISSING** |
| `artist.search` | ✅ | ✅ | **COMPLETE** |
| `artist.getSimilar` | ✅ | ❌ | **MISSING** |

**Missing**: 5 endpoints

### Track Endpoints (`track.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `track.getInfo` | ✅ | ❌ | **MISSING** |
| `track.getTags` | ✅ | ❌ | **MISSING** |
| `track.getSimilar` | ✅ | ❌ | **MISSING** |
| `track.getTopTags` | ✅ | ❌ | **MISSING** |
| `track.search` | ✅ | ✅ | **COMPLETE** |

**Missing**: 4 endpoints

### User Endpoints (`user.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `user.getFriends` | ✅ | ❌ | **MISSING** |
| `user.getPersonalTags` | ✅ | ❌ | **MISSING** |
| `user.getRecentTracks` | ✅ | ❌ | **MISSING** |
| `user.getInfo` | ✅ | ❌ | **MISSING** |
| `user.getTags` | ✅ | ❌ | **MISSING** |
| `user.getLovedTracks` | ✅ | ❌ | **MISSING** |
| `user.getTopArtists` | ✅ | ❌ | **MISSING** |
| `user.getTopAlbums` | ✅ | ❌ | **MISSING** |
| `user.getTopTracks` | ✅ | ❌ | **MISSING** |
| `user.getTopTags` | ✅ | ❌ | **MISSING** |
| `user.getWeeklyAlbumChart` | ✅ | ❌ | **MISSING** |
| `user.getWeeklyArtistChart` | ✅ | ❌ | **MISSING** |
| `user.getWeeklyChartList` | ✅ | ❌ | **MISSING** |
| `user.getWeeklyTrackChart` | ✅ | ❌ | **MISSING** |

**Missing**: 14 endpoints (all user endpoints are missing)

### Tag Endpoints (`tag.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `tag.getInfo` | ✅ | ✅ | **COMPLETE** |
| `tag.getTopArtists` | ✅ | ❌ | **MISSING** |
| `tag.getTopAlbums` | ✅ | ❌ | **MISSING** |
| `tag.getTopTracks` | ✅ | ❌ | **MISSING** |
| `tag.getTopTags` | ✅ | ✅ | **COMPLETE** |
| `tag.getSimilar` | ✅ | ❌ | **MISSING** |
| `tag.getWeeklyChartList` | ✅ | ❌ | **MISSING** |

**Missing**: 5 endpoints

### Chart Endpoints (`chart.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `chart.getTopArtists` | ✅ | ✅ | **COMPLETE** |
| `chart.getTopTracks` | ✅ | ✅ | **COMPLETE** |
| `chart.getTopTags` | ✅ | ✅ | **COMPLETE** |

**Missing**: 0 endpoints - **FULLY COVERED**

### Geo Endpoints (`geo.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `geo.getTopArtists` | ✅ | ✅ | **COMPLETE** |
| `geo.getTopTracks` | ✅ | ✅ | **COMPLETE** |

**Missing**: 0 endpoints - **FULLY COVERED**

### Auth Endpoints (`auth.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `auth.getMobileSession` | ✅ | ✅ | **COMPLETE** |

**Missing**: 0 endpoints - **FULLY COVERED**

### Scrobbling Endpoints (`track.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `track.updateNowPlaying` | ✅ | ✅ | **COMPLETE** |
| `track.scrobble` | ✅ | ✅ | **COMPLETE** |

**Missing**: 0 endpoints - **FULLY COVERED**

### Love Endpoints (`track.*`)

| Endpoint | Defined | Implemented | Status |
|----------|---------|-------------|--------|
| `track.love` | ✅ | ✅ | **COMPLETE** |

**Missing**: 0 endpoints - **FULLY COVERED**

## Implemented Methods Summary

### Currently Implemented (19 methods)

1. ✅ `album.getInfo` - Get album metadata (2 overloads: by name+artist, by MBID)
2. ✅ `album.getTopTags` - Get top tags for an album
3. ✅ `album.search` - Search for albums
4. ✅ `artist.getInfo` - Get artist metadata
5. ✅ `artist.search` - Search for artists
6. ✅ `track.search` - Search for tracks
7. ✅ `tag.getInfo` - Get tag information
8. ✅ `tag.getTopTags` - Get top tags globally
9. ✅ `chart.getTopArtists` - Get top artists chart
10. ✅ `chart.getTopTracks` - Get top tracks chart
11. ✅ `chart.getTopTags` - Get top tags chart
12. ✅ `geo.getTopArtists` - Get top artists by country
13. ✅ `geo.getTopTracks` - Get top tracks by country
14. ✅ `auth.getMobileSession` - Authenticate user
15. ✅ `track.updateNowPlaying` - Update now playing status
16. ✅ `track.scrobble` - Scrobble a track
17. ✅ `track.love` - Love/unlove a track
18. ✅ `checkLogin` - Verify credentials (helper method)

## Missing Implementations (29 endpoints)

### High Priority (User Data)
All user endpoints require authentication and are commonly used:
- `user.getRecentTracks` - Get user's recent scrobbles
- `user.getLovedTracks` - Get user's loved tracks
- `user.getInfo` - Get user profile information
- `user.getTopArtists` - Get user's top artists
- `user.getTopAlbums` - Get user's top albums
- `user.getTopTracks` - Get user's top tracks
- `user.getTopTags` - Get user's top tags
- `user.getWeeklyAlbumChart` - Get weekly album chart for user
- `user.getWeeklyArtistChart` - Get weekly artist chart for user
- `user.getWeeklyTrackChart` - Get weekly track chart for user
- `user.getWeeklyChartList` - Get list of available weekly charts
- `user.getFriends` - Get user's friends
- `user.getPersonalTags` - Get user's personal tags
- `user.getTags` - Get tags applied by user

### Medium Priority (Track & Artist Details)
- `track.getInfo` - Get track metadata
- `track.getTags` - Get tags for a track
- `track.getTopTags` - Get top tags for a track
- `track.getSimilar` - Get similar tracks
- `artist.getTopAlbums` - Get top albums by artist
- `artist.getTopTracks` - Get top tracks by artist
- `artist.getSimilar` - Get similar artists
- `artist.getTags` - Get tags for an artist
- `artist.getTopTags` - Get top tags for an artist

### Lower Priority (Album & Tag Details)
- `album.getTags` - Get tags for an album
- `tag.getTopArtists` - Get top artists for a tag
- `tag.getTopAlbums` - Get top albums for a tag
- `tag.getTopTracks` - Get top tracks for a tag
- `tag.getSimilar` - Get similar tags
- `tag.getWeeklyChartList` - Get weekly chart list for a tag

## Notes

1. **User Endpoints**: All user endpoints are currently missing. These require authentication and are essential for user-specific features.

2. **Track Endpoints**: Most track detail endpoints are missing. Only `track.search` is implemented.

3. **Artist Endpoints**: Missing many artist detail endpoints like `getTopAlbums`, `getTopTracks`, `getSimilar`.

4. **Complete Coverage**: Chart, Geo, Auth, and Scrobbling endpoints are fully covered.

5. **Search Functionality**: All search endpoints (album, artist, track) are implemented.

## Recommendations

1. **Priority 1**: Implement user endpoints (`user.getRecentTracks`, `user.getLovedTracks`, `user.getInfo`, etc.)
2. **Priority 2**: Implement track detail endpoints (`track.getInfo`, `track.getTags`, `track.getSimilar`)
3. **Priority 3**: Implement artist detail endpoints (`artist.getTopAlbums`, `artist.getTopTracks`, `artist.getSimilar`)
4. **Priority 4**: Implement remaining album and tag endpoints

## Files Reference

- **Endpoint Definitions**: `Sources/UmeroKit/Endpoints/*.swift`
- **Implementation**: `Sources/UmeroKit/UmeroKit.swift`
- **Models**: `Sources/UmeroKit/Models/*.swift`

