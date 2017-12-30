# William

William is a Network Debugging Library for iOS app.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Logging URLSession tasks
- [x] Logging WKWebview traffics
- [x] Display detail of request / response 
- [x] Syntax highlighting for HTML / CSS / JS / JSON (Thanks to [Highlightr](https://github.com/raspu/Highlightr))

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate William into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target '<Your Target Name>' do
  use_frameworks!

  # Add these two lines!
  pod 'Highlightr', :git => 'https://github.com/watanabetoshinori/Highlightr.git', :branch => 'master'
  pod 'William', :git => 'https://github.com/watanabetoshinori/William.git', :branch => 'master'

end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate William into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "watanabetoshinori/William"
```

Run `carthage update` to build the framework and drag the built `William.framework` into your Xcode project.

## Usage

### Show Main Panel

```swift
import William

William.show()
```

To start network logging, tap the bottom center button of Main Panel.

You can see the sample code from the [Example](https://github.com/watanabetoshinori/William/tree/master/Example) directory.

### Preview

<img  src="https://raw.githubusercontent.com/watanabetoshinori/William/master/Preview/1.png" width="375" height="812">
<img  src="https://raw.githubusercontent.com/watanabetoshinori/William/master/Preview/2.png" width="375" height="812">
<img  src="https://raw.githubusercontent.com/watanabetoshinori/William/master/Preview/3.png" width="375" height="812">


## License

William is released under the MIT license. [See LICENSE](https://github.com/watanabetoshinori/William/blob/master/LICENSE) for details.
