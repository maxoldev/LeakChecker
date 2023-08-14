//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

public func address(of instance: AnyObject) -> String {
    "\(Unmanaged.passUnretained(instance).toOpaque())"
}

public func typeAndAddress(of instance: AnyObject) -> String {
    "\(type(of: instance)) \(address(of: instance))"
}
