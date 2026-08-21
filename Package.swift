// swift-tools-version:5.9
import PackageDescription

// The publish job rewrites this block — everything else in this file is ours. Note the
// tags are load-bearing: KMMBridge looks for them verbatim and fails the publish if
// they've drifted.
// BEGIN KMMBRIDGE VARIABLES BLOCK (do not edit)
let remoteKotlinUrl = "https://github.com/code-payments/flipcash-shared-core-spm/releases/download/0.3.1/SharedCore.xcframework.zip"
let remoteKotlinChecksum = "6ba92cbd9b9c672c21302cb6be4b4a8f4941fad7387c95b9be5933c5433ad3b6"
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
