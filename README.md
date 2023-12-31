<p align="center"><img src="icon.png" alt="icon"/></p>

# LeakChecker

Simple memory leak checker based on weak reference examination.

<img src="demo.gif" width=400 alt="screen record"/>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LeakChecker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LeakChecker'
```

## Usage

1. Activate `LeakChecker.isEnabled = true` (eg from `AppDelegate.init`)
2. Use built-in handler `DefaultLeakDetectedHandler.isEnabled = true` or handle notification `NSNotification.Name.LeakChecker.leakDetected` by yourself
3. Add calls `checkLeak(of:)` for all objects may be accidentially retained before their expected deallocation

```swift
class YourViewController: UIViewController {

    private var viewModel = ViewModel()

    deinit {
        checkLeak(of: viewModel)
    }
```

## Author

Max Sol, maxoldev@gmail.com

## License

LeakChecker is available under the MIT license. See the LICENSE file for more info.

<a href="https://www.flaticon.com/free-icons/leak" title="leak icons">Leak icons created by Smashicons - Flaticon</a>