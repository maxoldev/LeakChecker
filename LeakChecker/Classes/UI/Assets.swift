//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

class AssetLocator {

    static var resourceBundle: Bundle {
        let url = Bundle(for: Self.self).resourceURL!.appendingPathComponent("LeakChecker.bundle")
        return Bundle(url: url)!
    }

}

extension UIImage {

    convenience init?(namedFromCurrentModule name: String) {
        self.init(named: name, in: AssetLocator.resourceBundle, compatibleWith: nil)
    }

}
