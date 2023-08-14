//
//  LeakChecker
//
//  Created by Max Sol on 11.08.2023.
//

import UIKit
import os

@objc
public class DefaultLeakDetectedHandler: NSObject {

    // MARK: - Public
    public static var leakDetectedBehavior = LeakDetectedBehavior.fromEnvironment()

    @objc
    public static var isEnabled = false {
        didSet {
            if isEnabled {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(onLeakDetected),
                    name: NSNotification.Name.LeakChecker.leakDetected,
                    object: nil
                )
            } else {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }

    @objc
    public static var isConsoleLoggingEnabled = true

    // MARK: - Private
    private static var debugOverlayWindow = DebugOverlayWindow()

    @objc
    private static func onLeakDetected(_ notification: Notification) {
        guard let leak = notification.userInfo?["payload"] as? LeakChecker.DetectedLeak else { return }

        let leakWarningString = LeakMessageFormatter.string(forLeak: leak)
        if isConsoleLoggingEnabled {
            logLeakWarningToConsole(leakWarningString)
        }

        switch self.leakDetectedBehavior {
        case .alert:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Potential leak detected", message: leakWarningString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                UIApplication.shared.delegate?.window??.rootViewController?.lastPresentedController.present(alert, animated: false, completion: nil)
            }

        case .stop:
            raise(SIGSTOP)

        case .toast:
            DispatchQueue.main.async {
                let text = LeakMessageAttributedFormatter.toastAttributedString(forLeak: leak)
                self.debugOverlayWindow.showToast(withAttributedText: text, onTapShow: LeakListViewController.self)
            }

        case .ignore:
            break
        }
    }

    private static let osLogSubsystem = "maxol.LeakChecker"

    private static func logLeakWarningToConsole(_ text: String) {
        let prefix = "🚰 "
        // There is issue in Console.app with displaying `OSLogType.debug` messages, so we use `default` instead
        let osLogType = OSLogType.default
        os_log("%{public}@", log: OSLog(subsystem: osLogSubsystem, category: "Leak"), type: osLogType, prefix + text)
    }
}
