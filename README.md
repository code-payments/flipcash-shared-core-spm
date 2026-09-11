# flipcash-shared-core-spm

Swift Package distribution for **SharedCore** — the Kotlin that the Flipcash iOS and Android apps
both run, built as an XCFramework and wrapped in a Swift API.

## What's shared

Not everything that could be shared is here. This is the code where a difference between the two
apps isn't cosmetic: a different derived key is a different account, a different signature is a
rejected transaction, and a different curve answer is a mispriced trade. UI, networking, and
storage stay native on both platforms.

### Scannable codes

The geometry behind the tip card and the scanner. `KikCodeSpec` holds the drawing spec — ring
count, bits per ring, the badge well ratio — which used to live twice, with ratios that agreed and
a frame that didn't. `KikCode.figure(payload:dimension:)` turns a payload into the mark and badge `CGPath`s the
code view draws, and `KikCode.svg(payload:)` renders the same code for export.

`LuminancePlane` is the decode side: how many bytes the native scanner reads out of a camera
frame's luminance plane, and how to unpad one whose rows are stride-aligned. Both apps had this
wrong in opposite directions before it moved here.

### Account keys and recovery

BIP39 phrase to seed, and SLIP-10 hardened derivation on top of it —
`SharedDerivation.seed(mnemonic:passphrase:)` and `SharedDerivation.derivedKey(seed:hardenedIndexes:)`.
An account's keys come from here, so the same recovery phrase has to produce the same address on
either platform.

### Signing and hashing

`SharedEd25519` for keypairs, signing, verification, and on-curve checks. `SharedHash` for SHA-256,
SHA-512, HMAC, and PBKDF2-SHA512. `Base58` for account addresses. These are the primitives Solana
addresses and transaction signatures are built from; both platforms compile the same vendored C
reference implementation underneath ed25519.

### Pricing

`SharedBondingCurve` — spot price at a given supply, tokens to value and back, and the rate for an
exchange, read against the discrete pricing and cumulative tables. This was two implementations
with different precision handling, `UInt128` on the Swift side and `BigDecimal` on the Kotlin one.

## This repository is generated

The source lives in [`code-payments/code-android-app`](https://github.com/code-payments/code-android-app)
under `kmp/shared-core`. Everything here except this README — `Package.swift`, `Sources`, `Tests`,
and the `SharedCore.xcframework.zip` release assets `Package.swift` points at — is produced by that
repo's **Publish SharedCore** workflow.

Do not edit `Package.swift` by hand; the next publish overwrites it.

## Using it

```swift
.package(url: "https://github.com/code-payments/flipcash-shared-core-spm", from: "0.6.0")
```

```swift
import SharedCoreKit
```

`SharedCoreKit` is the only product. It's a thin Swift target over the `SharedCore` binary
framework, so callers get Swift types and default arguments rather than the Kotlin framework's own
surface of `KotlinByteArray` and `.shared` singletons.

## Cutting a release

Run the **Publish SharedCore** workflow in `code-payments/code-android-app`, passing the version to
publish. It builds the XCFramework, uploads it as a release here, rewrites `Package.swift` to point
at that asset, tags the commit with the version, and writes the release notes from the commits
since the last publish. The Kotlin it was built from is tagged `shared-core/<version>` in
`code-android-app`.
