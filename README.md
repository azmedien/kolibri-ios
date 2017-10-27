# Kolibri

[![CI Status](http://img.shields.io/travis/slav.sarafski/Kolibri.svg?style=flat)](https://travis-ci.org/slav.sarafski/Kolibri)
[![Version](https://img.shields.io/cocoapods/v/Kolibri.svg?style=flat)](http://cocoapods.org/pods/Kolibri)
[![License](https://img.shields.io/cocoapods/l/Kolibri.svg?style=flat)](http://cocoapods.org/pods/Kolibri)
[![Platform](https://img.shields.io/cocoapods/p/Kolibri.svg?style=flat)](http://cocoapods.org/pods/Kolibri)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Requirements

iOS 9.0+
Xcode 8.3+
Swift 3.1+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build Alamofire 4.0+.

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod 'Kolibri'
end
```

Then, run the following command:

Kolibri is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
$ pod install
```

## Usage

### Making a Request

You must add following lines to project plist

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
...
    <key>KolibriParameters</key>
    <dict>
        <key>Fonts</key>
        <dict>
            <key>bold</key>
            <string></string>
            <key>italic</key>
            <string></string>
            <key>normal</key>
            <string></string>
        </dict>
        <key>kolibri_navigation_url</key>
        <string>http://kolibri.herokuapp.com/apps/MWuSQb4PB2cwbGXs62PpQ9Xz/runtime</string>
        <key>kolibri_netmetrix_url</key>
        <string>https://we-ssl.wemfbox.ch/cgi-bin/ivw/CP/apps/wireltern</string>
    </dict>
...
</dict>
</plist>

```

```swift
import Kolibri

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
...
Kolibri.shared.setup()
...
}
```

## Author

slav.sarafski, slav@spiritinvoker.com

## License

Kolibri is available under the MIT license. See the LICENSE file for more info.
