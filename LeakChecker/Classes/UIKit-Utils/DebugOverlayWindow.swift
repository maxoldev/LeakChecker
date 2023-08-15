//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

protocol OverlayWindowViewControllerProtocol: UIViewController {

    var onDismissBlock: (() -> Void)? { get set }

}

public final class DebugOverlayWindow: UIWindow {

    private enum Spec {
        static let toastAutoHideDelay: TimeInterval = 5
    }

    private let items: [DebugPanelsListItem]
    private var autoDismissToastTimer: Timer?

    private lazy var toast: OverlayToast = {
        let toast = OverlayToast()
        addSubview(toast)

        let topOffset: CGFloat
        if #available(iOS 11.0, tvOS 11.0, *) {
            topOffset = safeAreaInsets.top
        } else {
            topOffset = 0
        }
        toast.pin(to: self, leading: 0, top: topOffset, trailing: 0)

        toast.onHideBlock = { [weak self] in
            if self?.isViewControllerAdded == false {
                self?.hideWindow()
            }
        }
        return toast
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        return view
    }

    // MARK: - Public
    public var onHideBlock: (() -> Void)?

    @available(iOS 13.0, tvOS 13.0, *)
    public init(windowScene: UIWindowScene, items: [DebugPanelsListItem] = [], openOnShake: Bool = false) {
        self.items = items
        super.init(windowScene: windowScene)

        commonInit(openOnShake: openOnShake)
    }

    public init(items: [DebugPanelsListItem] = [], openOnShake: Bool = false) {
        self.items = items
        super.init(frame: UIScreen.main.bounds)

        commonInit(openOnShake: openOnShake)
    }

    public func showDebugPanels() {
        showNavigationController(with: DebugPanelsListViewController(items: items))
    }

    public func showToast(withAttributedText text: NSAttributedString, onTap: @escaping () -> Void) {
        toast.onTapBlock = onTap
        toast.show(withAttributedText: text)

        autoDismissToastTimer?.invalidate()
        autoDismissToastTimer = Timer.scheduledTimer(withTimeInterval: Spec.toastAutoHideDelay, repeats: false) { [weak toast] timer in
            timer.invalidate()
            toast?.hide()
        }

        showWindow()
    }

    public func showToast(withAttributedText text: NSAttributedString, onTapShow viewControllerClass: UIViewController.Type) {
        showToast(withAttributedText: text) { [weak self] in
            let vc = viewControllerClass.init()
            self?.showViewController(vc)
        }
    }

    // MARK: - Private
    private func commonInit(openOnShake: Bool) {
        backgroundColor = UIColor.clear
        isHidden = true
        windowLevel = UIWindow.Level(10000)// the topest view

        if openOnShake {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(onShake),
                name: Notification.Name.DebugOverlay.motionShake,
                object: nil
            )
        }
    }

    @objc
    private func onShake() {
        if isViewControllerAdded {
            removeViewController()
        } else {
            showDebugPanels()
        }
    }

    private func showWindow() {
        isHidden = false
    }

    private func hideWindow() {
        isHidden = true
        onHideBlock?()
    }

    private var isViewControllerAdded: Bool {
        return rootViewController != nil
    }

    private func showViewController(_ vc: UIViewController) {
        showNavigationController(with: vc)
    }

    private func showNavigationController(with vc: UIViewController) {
        showWindow()

        let debugPanelsNavigationController = DebugPanelsNavigationController(rootViewController: vc)
        debugPanelsNavigationController.onDismissBlock = { [weak self] in
            self?.removeViewController()
            self?.hideWindow()
        }
        rootViewController = debugPanelsNavigationController
    }

    private func showDebugPanelsListViewController() {
        let debugPanelsVC = DebugPanelsListViewController(items: items)
        showNavigationController(with: debugPanelsVC)
    }

    @objc
    private func close() {
        removeViewController()
        hideWindow()
    }

    private func removeViewController() {
        checkLeak(of: rootViewController)
        rootViewController = nil
    }

}
