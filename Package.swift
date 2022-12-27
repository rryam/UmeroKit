// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UmeroKit",
  platforms: [.iOS(.v13), .macOS(.v11), .watchOS(.v6), .tvOS(.v13)],
  products: [
    .library(name: "UmeroKit", targets: ["UmeroKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
  ],
  targets: [
    .target(name: "UmeroKit", dependencies: []),
    .testTarget(name: "UmeroKitTests", dependencies: ["UmeroKit"]),
  ]
)
