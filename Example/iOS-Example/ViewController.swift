//
//  LeakChecker
//
//  Created by Max Sol on 08/05/2023.
//

import UIKit
import LeakChecker

class ChildViewModel {

    private var block: (() -> Void)?

    init() {
        block = {
            _ = self // make a retain cycle
        }
    }

}

class ChildViewController: UIViewController {

    private var testObjectToLeak = NSObject()
    private var viewModel = ChildViewModel()

    deinit {
        checkLeak(of: viewModel) // a leak will be detected due to intentional retain cycle

        // hold the object for 5 sec.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [testObjectToLeak] in
            _ = testObjectToLeak
        }
        checkLeak(of: testObjectToLeak, expectedDeallocationInterval: 4) // the object is being held by closure at the time of the check
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onForceMemoryLeaks()
    }

    @objc
    private func onForceMemoryLeaks() {
        let vc = ChildViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()

            checkLeak(of: vc)
        }
    }

}

extension ViewController {

    private func setupUI() {
        view.backgroundColor = .blue

        let pushButton = UIButton()
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.setTitle("🚰 Force memory leaks", for: .normal)
        pushButton.addTarget(self, action: #selector(onForceMemoryLeaks), for: .primaryActionTriggered)
        view.addSubview(pushButton)

        NSLayoutConstraint.activate([
            pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
