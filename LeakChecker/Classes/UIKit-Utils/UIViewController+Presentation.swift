//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

extension UIViewController {

    public var lastPresentedController: UIViewController {
        var lastVC = self
        while lastVC.presentedViewController != nil {
            if let presentedVC = lastVC.presentedViewController {
                lastVC = presentedVC
            }
        }
        return lastVC
    }

}
