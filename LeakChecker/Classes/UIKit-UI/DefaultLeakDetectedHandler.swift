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
    public static let shared = DefaultLeakDetectedHandler()

    /// Loaded from env var `MAXOLDEV_LEAK_DETECTED_BEHAVIOR` or `.toast` by default
    public var leakDetectedBehavior = LeakDetectedBehavior.fromEnvironment() ?? .toast

    @objc
    public var isEnabled = false {
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
    public var isConsoleLoggingEnabled = true

    // MARK: - Private
    private var _debugOverlayWindow: DebugOverlayWindow?

    private var debugOverlayWindow: DebugOverlayWindow {
        get {
            if let window = _debugOverlayWindow {
                return window
            }

            let window = windowFromScene() ?? DebugOverlayWindow()
            _debugOverlayWindow = window
            return window
        }
    }

    private func windowFromScene() -> DebugOverlayWindow? {
        guard #available(iOS 13.0, tvOS 13.0, *) else {
            return nil
        }

        let windowScene = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.first
        if let windowScene = windowScene as? UIWindowScene {
            return DebugOverlayWindow(windowScene: windowScene)
        } else {
            return DebugOverlayWindow()
        }
    }

    @objc
    private func onLeakDetected(_ notification: Notification) {
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
                UIApplication.shared.delegate?.window??.rootViewController?.lastPresentedController
                    .present(alert, animated: false, completion: nil)
            }

        case .stop:
            raise(SIGSTOP)

        case .toast:
            DispatchQueue.main.async { [weak self] in
                let text = LeakMessageAttributedFormatter.toastAttributedString(forLeak: leak)
                self?.debugOverlayWindow.showToast(withAttributedText: text, onTapShow: LeakListViewController.self)
                self?.debugOverlayWindow.onHideBlock = {
                    self?._debugOverlayWindow = nil
                }
            }

        case .ignore:
            break
        }
    }

    private let osLogSubsystem = "maxoldev.LeakChecker"

    private func logLeakWarningToConsole(_ text: String) {
        let prefix = "🚰 "
        // There is an issue in Console.app with displaying `OSLogType.debug` messages, so we use `default` instead
        let osLogType = OSLogType.default
        os_log("%{public}@", log: OSLog(subsystem: osLogSubsystem, category: "Leak"), type: osLogType, prefix + text)
    }
}
