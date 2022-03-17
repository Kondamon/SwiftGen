// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "SwiftGen",
  platforms: [
    .macOS(.v10_11),
  ],
  products: [
    .executable(name: "swiftgen", targets: ["SwiftGen"]),
    .library(name: "SwiftGenCLI", targets: ["SwiftGenCLI"]),
    .library(name: "SwiftGenKit", targets: ["SwiftGenKit"]),
    .plugin(name: "SwiftGenPlugin", targets: ["SwiftGenPlugin"])
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6"),
    .package(url: "https://github.com/kylef/Commander.git", from: "0.9.1"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
    .package(url: "https://github.com/kylef/Stencil.git", from: "0.14.1"),
    .package(url: "https://github.com/shibapm/Komondor.git", from: "1.1.1"),
    .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.8.0"),
    .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.7")
  ],
  targets: [
    .target(name: "SwiftGen", dependencies: [
      "SwiftGenCLI"
    ]),
    .target(name: "SwiftGenCLI", dependencies: [
      "Commander",
      "Kanna",
      "PathKit",
      "Stencil",
      "StencilSwiftKit",
      "SwiftGenKit",
      "Yams"
    ], resources: [
      .copy("templates")
    ]),
    .target(name: "SwiftGenKit", dependencies: [
      "Kanna",
      "PathKit",
      "Yams"
    ]),
    .plugin(
      name: "SwiftGenPlugin",
      capability: .buildTool(),
      dependencies: ["SwiftGenBinaryTarget"]
     ),
    .binaryTarget(
      name: "SwiftGenBinaryTarget",
      url: "https://github.com/Kondamon/SwiftGen/raw/stable/swiftgen-executables.zip",
      checksum: "6b4e5cde1c064aeb911b644ab8ecdfa93449634a9c38dcc0ca05ef73c3d631fd"
     ),
    .testTarget(name: "SwiftGenKitTests", dependencies: [
      "SwiftGenKit",
      "TestUtils"
    ]),
    .testTarget(name: "SwiftGenTests", dependencies: [
      "SwiftGenCLI",
      "TestUtils"
    ]),
    .testTarget(name: "TemplatesTests", dependencies: [
      "StencilSwiftKit",
      "SwiftGenKit",
      "TestUtils"
    ]),
    .target(name: "TestUtils", dependencies: [
      "PathKit",
      "SwiftGenKit",
      "SwiftGenCLI"
    ], exclude: [
      "Fixtures/CompilationEnvironment"
    ], resources: [
      .copy("Fixtures/Configs"),
      .copy("Fixtures/Generated"),
      .copy("Fixtures/Resources"),
      .copy("Fixtures/StencilContexts")
    ])
  ],
  swiftLanguageVersions: [.v5]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
  "komondor": [
    "pre-commit": [
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:code",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:tests",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:output"
    ],
    "pre-push": [
      "PATH=\"~/.rbenv/shims:$PATH\" bundle exec rake spm:test"
    ]
  ],
]).write()
#endif
