//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

@available(iOS 10.0, *)
@available(tvOS, unavailable)
final class AppRelaunchBarButtonItem: UIBarButtonItem {

    static func make(title: String = "Relaunch") -> UIBarButtonItem {
        let item = AppRelaunchBarButtonItem(title: title, style: .plain, target: nil, action: #selector(onTap))
        item.target = item
        return item
    }

    @objc private func onTap() {
        // Create a local notification
        let content = UNMutableNotificationContent()
        content.title = "Tap to relaunch"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.3, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        // Kill the app
        exit(0)
    }

}

@available(iOS 10.0, *)
@available(tvOS, unavailable)
extension UIViewController {

    public func addAppRelaunchBarButtonItem() {
        var rightBarButtonItems = navigationItem.rightBarButtonItems ?? []
        rightBarButtonItems.insert(AppRelaunchBarButtonItem.make(), at: 0)
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }

}
