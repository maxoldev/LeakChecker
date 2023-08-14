//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

public extension UITableViewCell {
    
    @objc
    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
