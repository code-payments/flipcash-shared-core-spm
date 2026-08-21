// swift-tools-version:5.9
import PackageDescription

// The publish job rewrites this block — everything else in this file is ours. Note the
// tags are load-bearing: KMMBridge looks for them verbatim and fails the publish if
// they've drifted.
// BEGIN KMMBRIDGE VARIABLES BLOCK (do not edit)
let remoteKotlinUrl = "https://api.github.com/repos/code-payments/flipcash-shared-core-spm/releases/assets/524246398.zip"
let remoteKotlinChecksum = "2937ae63738535f7cd43200e110d2cfdeb02b4cb4ccc5ec1a1d3e065f6557303"
let packageName = "SharedCore"
// END KMMBRIDGE BLOCK

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // The only product on purpose. Callers get Swift types; the Kotlin framework's
        // own surface — `KotlinByteArray`, `.shared` singletons, no default arguments —
        // stays behind this target.
        .library(
            name: "SharedCoreKit",
            targets: ["SharedCoreKit"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: packageName,
            url: remoteKotlinUrl,
            checksum: remoteKotlinChecksum
        ),
        .target(
            name: "SharedCoreKit",
            dependencies: [.target(name: packageName)]
        ),
        .testTarget(
            name: "SharedCoreKitTests",
            dependencies: ["SharedCoreKit"]
        ),
    ]
)
