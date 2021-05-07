// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MockServer",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "MockServer",
      targets: ["MockServer"]),
  ],
  dependencies: [
    .package(name: "Swifter",
             url: "https://github.com/httpswift/swifter.git",
             .upToNextMajor(from: "1.5.0"))
  ],
  targets: [
    .target(
      name: "MockServer",
      dependencies: ["Swifter"],
      resources: [
        .process("Json")
      ]),
    .testTarget(
      name: "MockServerTests",
      dependencies: ["MockServer"]),
  ]
)
