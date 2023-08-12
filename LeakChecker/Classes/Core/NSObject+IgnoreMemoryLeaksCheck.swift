//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import Foundation

extension NSObject {

    /// Increase ignore counter. Works in DEBUG only
    @objc
    public func cmIgnoreNextMemoryLeakCheck() {
#if DEBUG
        var counter = ignoreNextMemoryLeakCheckCallsCount
        counter += 1
        objc_setAssociatedObject(
            self,
            &AssociatedKey.cmIgnoreNextMemoryLeakCheck,
            counter,
            .OBJC_ASSOCIATION_COPY
        )
#endif
    }

    /// Decrease ignore counter. Works in DEBUG only
    @objc
    public func cmCancelIgnoreNextMemoryLeakCheck() {
#if DEBUG
        var counter = ignoreNextMemoryLeakCheckCallsCount
        counter = max(0, counter - 1)
        objc_setAssociatedObject(
            self,
            &AssociatedKey.cmIgnoreNextMemoryLeakCheck,
            counter,
            .OBJC_ASSOCIATION_COPY
        )
#endif
    }

    /// Check whether memory leak check should be ignored. Works in DEBUG only, in release returns false
    @objc
    public var cmShouldIgnoreMemoryLeakCheck: Bool {
#if DEBUG
        return ignoreNextMemoryLeakCheckCallsCount > 0
#else
        return false
#endif
    }

    private enum AssociatedKey {
        // Use selector as it is unique string
        static var cmIgnoreNextMemoryLeakCheck: Void?
    }

    private var ignoreNextMemoryLeakCheckCallsCount: Int {
        objc_getAssociatedObject(self, &AssociatedKey.cmIgnoreNextMemoryLeakCheck) as? Int ?? 0
    }
}
