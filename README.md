# UmeroKit

Easily use Last.fm in your apps.

<p align="center">
  <img src= "https://github.com/rryam/UmeroKit/blob/main/UmeroKit.png" alt="UmeroKit Logo" width="256"/>
</p>

## Quickstart 

Get started by getting the API key from last.fm and using the following method to configure UmeroKit: 

```swift 
UmeroKit.configure(withAPIKey: "YOUR_LASTFM_API_KEY")
```

Then you can easily use the methods to fetch tags, albums, artists, charts with the default instance of UmeroKit, `Umero`. Directly call the methods on this instance: 

```swift 
var artists: [UArtist] = []

UmeroKit.configure(withAPIKey: apiKey)

let chart = try await Umero.topChartArtists()

self.artists = chart.artists

let tags = try await Umero.topChartTags()
print(tags)
```
