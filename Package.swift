// swift-tools-version: 5.10

import Foundation
import PackageDescription

let gccIncludePrefix =
    "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"

let playdateSDKPath: String = if let path = Context.environment["PLAYDATE_SDK_PATH"] {
    path
} else {
    "\(Context.environment["HOME"]!)/Developer/PlaydateSDK/"
}

let simulatorSettings: [SwiftSetting] = [
    .enableExperimentalFeature("Embedded"),
    .unsafeFlags([
        "-Xfrontend", "-disable-objc-interop",
        "-Xfrontend", "-disable-stack-protector",
        "-Xfrontend", "-function-sections",
        "-Xfrontend", "-gline-tables-only",
        "-Xcc", "-DTARGET_EXTENSION",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed",
        "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
        "-I", "\(playdateSDKPath)/C_API",
        
    ]),
]

let package = Package(
    name: "PDKitUtils",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "PDKitUtils", targets: ["PDKitUtils"])
    ],
    dependencies: [
        .package(name: "PlaydateKit", path: "../PlaydateKit"),
    ],
    targets: [
        .target(
            name: "PDKitUtils",
            swiftSettings: simulatorSettings
        ),
        // This is a copy of PDKitUtils it's a simple soft link to PDKitUtils folder, without the simulator settings
        // it can be used in the test target
        .target(name: "PDKitUtilsStd"),
        .testTarget(
            name: "PDKitUtilsTests",
            dependencies: ["PDKitUtilsStd"]
        )
    ]
)
