//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

public final class LeakListViewController: UIViewController, UINavigationBarDelegate {

    private var notificationToken: Any?

    private let leakWatchTextView = UITextView() ~> {
        $0.backgroundColor = .clear
        $0.textContainer.lineBreakMode = .byCharWrapping
#if os(iOS)
        $0.isEditable = false
#endif
        $0.isSelectable = true
        $0.bounces = true
        $0.alwaysBounceVertical = true
    }

    private let blurView = UIVisualEffectView() ~> {
        if #available(iOS 10.0, *) {
            $0.effect = UIBlurEffect(style: .regular)
        } else {
            $0.effect = UIBlurEffect(style: .light)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detected Leaks"

        view.addSubview(blurView)
        view.addSubview(leakWatchTextView)

        blurView.pin(to: view)
        leakWatchTextView.pin(to: view)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(update),
            name: NSNotification.Name.LeakChecker.leakDetected,
            object: nil
        )

        update()
    }

    @objc
    private func update() {
        let newLeakWatchTextViewText = NSMutableAttributedString()

        let leaks = LeakChecker.detectedLeaks.reversed()
        for leak in leaks {
            newLeakWatchTextViewText.append(LeakMessageAttributedFormatter.leakListAttributedString(forLeak: leak))
            newLeakWatchTextViewText.append(NSAttributedString(string: "\n\n"))
        }

        DispatchQueue.main.async {
            self.leakWatchTextView.attributedText = newLeakWatchTextViewText
        }
    }

}

// MARK: - UINavigationBarDelegate
extension LeakListViewController {

    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

}
