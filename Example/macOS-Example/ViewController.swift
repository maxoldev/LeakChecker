//
//  macOS-Example
//
//  Created by Max Sol on 10.08.2023.
//

import Cocoa
import LeakChecker

class ViewModel {

    private var block: (() -> Void)?

    init() {
        block = {
            _ = self // make a retain cycle
        }
    }

}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        onForceMemoryLeaks()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func onForceMemoryLeaks() {
        let viewModel = ViewModel()
        checkLeak(of: viewModel)
    }

}
