//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

public enum LeakDetectedBehavior: String {

    case ignore, toast, alert, stop

}

extension LeakDetectedBehavior {

    public static func fromEnvironment() -> LeakDetectedBehavior {
        guard let behaviorString = LeakCheckerProcessInfo.leakDetectedBehavior else {
            return .toast
        }
        if behaviorString.isEmpty {
            return .ignore
        }
        guard let behavior = LeakDetectedBehavior(rawValue: behaviorString) else {
            return .toast
        }
        return behavior
    }

}
