//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

public enum LeakDetectedBehavior: String {

    case ignore, toast, alert, stop

}

extension LeakDetectedBehavior {

    public static func fromEnvironment() -> LeakDetectedBehavior? {
        guard let behaviorString = LeakCheckerProcessInfo.leakDetectedBehavior,
              !behaviorString.isEmpty,
              let behavior = LeakDetectedBehavior(rawValue: behaviorString)
        else {
            return nil
        }
        return behavior
    }

}
