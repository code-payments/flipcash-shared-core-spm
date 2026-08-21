# flipcash-shared-core-spm

Swift Package distribution for **SharedCore** — the Kotlin Multiplatform core shared by the
Flipcash Android and iOS apps (key derivation, encryption primitives, scannable-code geometry).

## This repository is generated

The source lives in [`code-payments/code-android-app`](https://github.com/code-payments/code-android-app)
under `kmp/shared-core`. Everything here — `Package.swift` and the `SharedCore.xcframework.zip`
release assets it points at — is produced by that repo's **Publish SharedCore** workflow.

Do not edit `Package.swift` by hand; the next publish overwrites it.

## Using it

```swift
.package(url: "https://github.com/code-payments/flipcash-shared-core-spm", from: "0.1.0")
```

```swift
import SharedCore
```

The package, product, and framework are all named `SharedCore` regardless of this repository's name.

## Cutting a release

Run the **Publish SharedCore** workflow in `code-payments/code-android-app`, passing the version to
publish. It builds the XCFramework, uploads it as a release here, rewrites `Package.swift` to point
at that asset, and tags the commit with the version.
