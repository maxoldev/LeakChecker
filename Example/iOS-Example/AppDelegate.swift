//
//  LeakChecker
//
//  Created by Max Sol on 08/05/2023.
//

import UIKit
import LeakChecker

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        activateLeakChecker()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        return true
    }

    private func activateLeakChecker() {
        // Just enable the checker
        LeakChecker.isEnabled = true

        // Use built-in handler...
        DefaultLeakDetectedHandler.shared.isEnabled = true
        // You can override DefaultLeakDetectedHandler's leak detected behavior from code
        // Value from env var `MAXOLDEV_LEAK_DETECTED_BEHAVIOR` or `.toast` is used by default 
        // DefaultLeakDetectedHandler.shared.leakDetectedBehavior = .alert

        // ...or handle notification by yourself
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(onLeakDetected),
//            name: NSNotification.Name.LeakChecker.leakDetected,
//            object: nil
//        )
    }

    @objc
    private func onLeakDetected(_ notification: Notification) {
        guard let leak = notification.userInfo?["payload"] as? LeakChecker.DetectedLeak else { return }

        let leakWarningString = LeakMessageFormatter.string(forLeak: leak)
        // log warning, using print or or_log or send to server
        print("🚰 " + leakWarningString)
    }

}
