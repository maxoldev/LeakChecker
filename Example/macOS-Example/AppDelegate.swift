//
//  macOS-Example
//
//  Created by Max Sol on 10.08.2023.
//

import Cocoa
import LeakChecker

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    override init() {
        super.init()
        activateLeakChecker()
    }

    private func activateLeakChecker() {
        LeakChecker.isEnabled = true

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
        print("🚰 " + leakWarningString)
    }

}
