//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

public extension Notification.Name {

    enum DebugOverlay {
        static let motionShake = Notification.Name("DebugOverlay.motionShake")
    }

}

extension UIWindow {
    
    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: Notification.Name.DebugOverlay.motionShake, object: nil)
        }
    }

}
