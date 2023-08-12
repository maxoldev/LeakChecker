//
//  AppDelegate.swift
//  tvOS-Example
//
//  Created by Max Sol on 10.08.2023.
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
        LeakChecker.isEnabled = true

        // Use built-in handler...
        DefaultLeakDetectedHandler.isEnabled = true

        // ...or handle notification by yourself
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLeakDetected),
            name: NSNotification.Name.LeakChecker.leakDetected,
            object: nil
        )
    }

    @objc
    private func onLeakDetected(_ notification: Notification) {
        guard let leak = notification.userInfo?["payload"] as? LeakChecker.DetectedLeak else { return }

        let leakWarningString = LeakMessageFormatter.string(forLeak: leak)
        // log warning, using print or or_log or send to server
        //print("🚰 " + leakWarningString)
        _ = leakWarningString
    }

}
