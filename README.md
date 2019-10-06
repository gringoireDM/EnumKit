<p align="center">
<img src="./enumKit.png" alt="EnumKit"/>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" />
    <a href="https://travis-ci.org/gringoireDM/EnumKit">
        <img src="https://travis-ci.org/gringoireDM/EnumKit.svg?branch=master" alt="Build Status" />
    </a>
    <a href="https://codecov.io/gh/gringoireDM/EnumKit">
        <img src="https://codecov.io/gh/gringoireDM/EnumKit/branch/master/graph/badge.svg" alt="codecov" />
    </a>
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftPM-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <img src="https://cocoapod-badges.herokuapp.com/v/EnumKit/badge.png" alt="cocoapods" />
</p>


`EnumKit` is a library that gives you the ability to simply access an enum associated value, without having to use pattern matching. It also offers many utilities available to other swift types, like updatability of an associated value and transformations. 

`EnumKit` comes with an extension of `Sequence` to extend functions like `compactMap`, `flatMap`, `filter` to Sequences of enums cases.

All you need to do to get these features is to declare your enum conformant to the marker protocol `CaseAccessible`.

```swift
enum MyEnum: CaseAccessible { ... }
```

For more please read our [wiki](https://github.com/gringoireDM/EnumKit/wiki).

## Usage
  * [Access an associated value](https://github.com/gringoireDM/EnumKit/wiki/Access-an-associated-value)
  * [Matching cases](https://github.com/gringoireDM/EnumKit/wiki/Matching-Cases)
  * [Updating an enum value](https://github.com/gringoireDM/EnumKit/wiki/Updating-an-enum-value)
  * [Transform associated values](https://github.com/gringoireDM/EnumKit/wiki/Transform-associated-values)


## Requirements

### V 1.0.0

* Xcode 10.2
* Swift 5.0

### V 1.1.0

* Xcode 11
* Swift 5.1

## Installation

EnumKit offers [cocoapods](https://cocoapods.org) and [swiftPM](https://swift.org/package-manager)

### Via Cocoapods

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'EnumKit', '~> 1.1.0'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

### via Swift Package Manager

Create a `Package.swift` file.

```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "YourProjectName",
  dependencies: [
    .package(url: "https://github.com/gringoireDM/EnumKit.git", from: "1.1.0")
  ],
  targets: [
    .target(name: "YourProjectName", dependencies: ["EnumKit"])
  ]
)
```

```bash
$ swift build
```

# External Resources

- [RxEnumKit](https://github.com/gringoireDM/RxEnumKit): Extension for RxSwift Observables and SharedSequences to work with Streams of enum cases.
- [Swift Enums, Mind the Gap: EnumKit to the Rescue](https://medium.com/better-programming/swift-enums-mind-the-gap-3573378d2d9f): Medium article on EnumKit and RxEnumKit
