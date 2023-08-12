# LeakChecker

Simple memory leak checker based on weak reference examination.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LeakChecker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LeakChecker'
```

For systems without UIKit (tvOS, macOS) you can use core functionality with your own UI or just console logging or `LeakDetectedBehavior.stop`:
 
```ruby
pod 'LeakChecker', :subspecs => ['Core']
``` 

## Usage

1. Activate `LeakChecker.isEnabled = true` (eg from `AppDelegate.init`)
2. Use built-in handler `DefaultLeakDetectedHandler.isEnabled = true` or handle notification `NSNotification.Name.LeakChecker.leakDetected` by yourself
3. Add calls `checkLeak(of:)` for all objects may be accidentially retained before their expected deallocation

## Author

Max Sol, mswork85@gmail.com

## License

LeakChecker is available under the MIT license. See the LICENSE file for more info.