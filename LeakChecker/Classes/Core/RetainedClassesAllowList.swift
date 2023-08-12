//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import Foundation

/// You can add class names for which memory leaks checks should not be performed in this list
/// (e.g. system view controllers not deleted after rmoving from parent)
@objc
public class RetainedClassesAllowList: NSObject {

    private static let allowedClassNames: Set<String> = [
        "UICompatibilityInputViewController",
        "UISystemInputAssistantViewController"
    ]

    @objc
    public static func contains(_ obj: NSObject) -> Bool {
        let className = String(describing: type(of: obj))
        return allowedClassNames.contains(className)
    }

}
