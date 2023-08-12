//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit
import Combine

final class OverlayToast: UIView {

    private enum Spec {
        static let insets: CGFloat = 8
    }

    private let label = UILabel() ~> {
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    private let closeButton = UIButton(type: .system) ~> {
        $0.tintColor = .black
        let iconName = "close"
        guard let icon = UIImage(namedFromCurrentModule: iconName) else {
            fatalError("Unable to load image named \(iconName).")
        }

        $0.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    var onTapBlock: () -> Void = {}
    var onHideBlock: () -> Void = {}

    func show(withAttributedText text: NSAttributedString) {
        layer.removeAllAnimations() // stop existing animations if needed

        label.attributedText = text

        alpha = 1
        isHidden = false
        pulse()
    }

    func hide() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true

                self.onHideBlock()
            }
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        // swiftlint:disable:next disable_uicolor_init
        backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)

        addSubview(label)
        addSubview(closeButton)

        label.pin(to: self, leading: Spec.insets, top: 30, trailing: -Spec.insets, bottom: -Spec.insets)
        closeButton.pin(to: self, top: 0, trailing: 0)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        closeButton.addTarget(self, action: #selector(onClose), for: .primaryActionTriggered)

        let tapRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(tapRecognizer)
        tapRecognizer.addTarget(self, action: #selector(onTap))

        let swipeRecognizer = UISwipeGestureRecognizer()
        swipeRecognizer.direction = .up
        addGestureRecognizer(swipeRecognizer)
        swipeRecognizer.addTarget(self, action: #selector(onClose))
    }

    @objc
    private func onTap() {
        onTapBlock()
    }

    @objc
    private func onClose() {
        hide()
    }

    private func pulse() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = backgroundColor?.cgColor
        animation.toValue = UIColor.red.cgColor
        layer.add(animation, forKey: "backgroundColor")
    }

}
