//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import Foundation

enum LeakCheckerProcessInfo {

    static let leakDetectedBehavior = ProcessInfo.processInfo.environment["MAXOLDEV_LEAK_DETECTED_BEHAVIOR"]

}
