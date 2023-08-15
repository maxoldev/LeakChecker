//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import Foundation

public extension NSNotification.Name {

    enum LeakChecker {
        /// Notification is called on a BACKGROUND thread
        public static let leakDetected = NSNotification.Name("LeakChecker.leakDetected")
    }

}

/// Use `context` to hint where the leak is occured
public func checkLeak(
    of objects: AnyObject?...,
    context: String? = nil,
    expectedDeallocationInterval: TimeInterval = LeakChecker.defaultExpectedDeallocationInterval)
{
    for object in objects {
        LeakChecker.checkLeak(of: object, context: context, expectedDeallocationInterval: expectedDeallocationInterval)
    }
}

public final class LeakChecker: NSObject {

    // MARK: - Private
    private static var _detectedLeaks = [DetectedLeak]()
    private static var queue = DispatchQueue(label: "maxoldev.LeakChecker.queue", attributes: .concurrent)

    // MARK: - Public
    public final class DetectedLeak: NSObject {
        // don't store pointer directly to avoid extra references
        public let objectPointerString: String
        public let objectClass: AnyClass
        public let context: String?
        public let expectedDeallocationInterval: TimeInterval
        public let date: Date

        init(object: AnyObject, context: String?, expectedDeallocationInterval: TimeInterval, date: Date) {
            objectPointerString = "\(Unmanaged.passUnretained(object).toOpaque())"
            objectClass = type(of: object)
            self.context = context
            self.expectedDeallocationInterval = expectedDeallocationInterval
            self.date = date
        }
    }

    @objc
    public static var isEnabled = false

    @objc
    public static var defaultExpectedDeallocationInterval = 2.0

    @objc
    public static var detectedLeaks: [DetectedLeak] {
        queue.sync {
            _detectedLeaks
        }
    }

    @objc
    static public func checkLeak(
        of object: AnyObject?,
        context: String?,
        expectedDeallocationInterval: TimeInterval)
    {
        if isEnabled && object != nil {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + expectedDeallocationInterval) { [weak object] in
                if let object = object {
                    let leak = DetectedLeak(
                        object: object,
                        context: context,
                        expectedDeallocationInterval: expectedDeallocationInterval,
                        date: Date()
                    )
                    queue.sync(flags: .barrier) {
                        _detectedLeaks.append(leak)
                    }

                    let userInfo = ["payload": leak]
                    NotificationCenter.default.post(
                        name: NSNotification.Name.LeakChecker.leakDetected,
                        object: nil,
                        userInfo: userInfo
                    )
                }
            }
        }
    }

}
