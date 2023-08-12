//
//  LeakMessageFormatter.swift
//  LeakChecker
//
//  Created by Max Sol on 10.08.2023.
//

import Foundation

@objc
public class LeakMessageFormatter: NSObject {

    // MARK: - External
    public static func string(forLeak leak: LeakChecker.DetectedLeak) -> String {
        var text = "<\(leak.objectClass): \(leak.objectPointerString)> has not been deallocated after expected \(leak.expectedDeallocationInterval) sec."
        if let context = leak.context {
            text.append(" (context: \(context))")
        }
        return text
    }

}
