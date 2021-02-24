// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PromotedAIMetricsSDK",
  products: [
    .library(
      name: "PromotedAIMetricsSDK",
      targets: [
        "PromotedAIMetricsSDK",
      ]),
  ],
  dependencies: [
    .package(name: "GTMSessionFetcher", url: "https://github.com/google/gtm-session-fetcher", from: "1.5.0"),
    .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf", from: "1.15.0"),
  ],
  targets: [
    .target(
      name: "PromotedAIMetricsSDK",
      dependencies: [
        .product(name: "GTMSessionFetcherCore", package: "GTMSessionFetcher"),
        .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
        "SchemaProtos",
      ],
      exclude: [
        "ObjC"
      ]),
    .testTarget(
      name: "PromotedAIMetricsSDKTests",
      dependencies: [
        "PromotedAIMetricsSDK"
      ]),
    .target(
      name: "SchemaProtos",
      dependencies: [
        .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
      ],
      exclude: [
        "objc"
      ])
  ]
)
