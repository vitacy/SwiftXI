// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftXI",
    products: [
        .executable(name: "SwiftHello", targets: ["SwiftHello"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.13.0")
        ],
    targets: [
        .target(
            name: "SkiaKitCxx",
            path: "Sources/SkiaKitCxx/public",
            publicHeadersPath: ".",
            cxxSettings: [
                .unsafeFlags([
                    "-std=c++20",
                ]),
            ]
        ),
        .target(
            name: "SkiaKitCxxImpl",
            dependencies: ["SkiaKitCxx"],
            path: "Sources/SkiaKitCxx",
            exclude: ["public"],
            publicHeadersPath: ".",
            cxxSettings: [
                .define("NOMINMAX"),
                .define("_CRT_SECURE_NO_WARNINGS"),
                .define("_HAS_EXCEPTIONS=0"),
                .define("SK_GL"),
                .define("SK_SUPPORT_GPU=1"),
                .define("_SILENCE_CXX20_IS_POD_DEPRECATION_WARNING"),
                .define("WIN32_LEAN_AND_MEAN"),
                .define("NDEBUG"),
                .unsafeFlags([
                    "-I", "ThirdParty/skia", 
                    "-I", "public",
                    "-std=c++20",
                ])
            ],
            linkerSettings:[
                .linkedLibrary("ThirdParty/skia/out/ClangCl/skia.lib"),
                .linkedLibrary("Opengl32"),
            ]
        ),
        
        .target(
            name: "SkiaKit",
            dependencies: [
                "SkiaKitCxx"
            ],
            publicHeadersPath: "public",
            swiftSettings: [
                .unsafeFlags([
                    "-v",
                    "-I", "public", 
                    "-enable-experimental-cxx-interop",
                    "-emit-objc-header",
                    "-emit-objc-header-path", "public/SkiaKit/SkiaKit.h"
                ])
            ]
        ),
        .target(
            name: "SwiftXI",
            dependencies: [
                "SkiaKit",
                "SkiaKitCxxImpl",
                "OpenCombine",
                .product(name: "OpenCombineFoundation", package: "OpenCombine"),
                .product(name: "OpenCombineDispatch", package: "OpenCombine")],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-experimental-cxx-interop",
                ]) 
            ] 
        ),
        .target(
            name: "SwiftUI",
            dependencies: [
                "SwiftXI"
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-experimental-cxx-interop"
                ])
            ]
        ),
        .executableTarget(
            name: "SwiftHello",
            dependencies: ["SwiftUI"],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-experimental-cxx-interop"
                ])
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "/ignore:4217"
                ])
            ]
        ),
        .testTarget(
            name: "swiftuiTests",
            dependencies: ["SwiftHello"]
        ),
    ]
)
