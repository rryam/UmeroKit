import Foundation
import Testing
@testable import UmeroKit

@Suite("Scrobbling Request Tests", .serialized)
struct ScrobblingRequestTests {
  @Test("Form encoder escapes ampersands and plus signs")
  func formEncoderEscapesReservedCharacters() throws {
    let data = try UFormURLEncoder.formData(from: [
      "artist": "Tom & Jerry",
      "track": "A+B & C"
    ])

    let body = try #require(String(data: data, encoding: .utf8))
    #expect(body.contains("artist=Tom%20%26%20Jerry"))
    #expect(body.contains("track=A%2BB%20%26%20C"))
    #expect(!body.contains("A+B & C"))
    #expect(!body.contains("Tom & Jerry"))
  }

  @Test("Scrobbling reuses authenticated session key")
  func scrobblingReusesAuthenticatedSessionKey() async throws {
    LastFmMockURLProtocol.storage.reset()
    URLProtocol.registerClass(LastFmMockURLProtocol.self)
    defer {
      URLProtocol.unregisterClass(LastFmMockURLProtocol.self)
      LastFmMockURLProtocol.storage.reset()
    }

    let umero = UmeroKit(
      apiKey: "test-api-key",
      secret: "test-secret",
      username: "test-user",
      password: "test-password"
    )

    try await umero.scrobble(track: "A+B & C", artist: "Tom & Jerry")
    try await umero.scrobble(track: "Second Track", artist: "Tom & Jerry")

    let bodies = LastFmMockURLProtocol.storage.bodyStrings()
    #expect(bodies.count == 3)
  }
}

private final class LockedRequestStorage: @unchecked Sendable {
  private let lock = NSLock()
  private var bodies: [String] = []

  func append(_ request: URLRequest) -> Int {
    let body = Self.bodyString(from: request) ?? ""

    return lock.withLock {
      bodies.append(body)
      return bodies.count
    }
  }

  func reset() {
    lock.withLock {
      bodies = []
    }
  }

  func bodyStrings() -> [String] {
    lock.withLock {
      bodies
    }
  }

  private static func bodyString(from request: URLRequest) -> String? {
    if let body = request.httpBody {
      return String(data: body, encoding: .utf8)
    }

    guard let stream = request.httpBodyStream else {
      return nil
    }

    stream.open()
    defer { stream.close() }

    var data = Data()
    let bufferSize = 1_024
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    defer { buffer.deallocate() }

    while stream.hasBytesAvailable {
      let bytesRead = stream.read(buffer, maxLength: bufferSize)
      if bytesRead < 0 {
        return nil
      }
      if bytesRead == 0 {
        break
      }
      data.append(buffer, count: bytesRead)
    }

    return String(data: data, encoding: .utf8)
  }
}

private final class LastFmMockURLProtocol: URLProtocol, @unchecked Sendable {
  static let storage = LockedRequestStorage()

  override class func canInit(with request: URLRequest) -> Bool {
    request.url?.host == "ws.audioscrobbler.com"
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }

  override func startLoading() {
    let requestCount = Self.storage.append(request)

    let data: Data

    if requestCount == 1 {
      data = Data("""
      {"session":{"name":"test-user","key":"cached-session-key","subscriber":0}}
      """.utf8)
    } else {
      data = Data("{}".utf8)
    }

    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: ["Content-Type": "application/json"]
    )!

    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: data)
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}
