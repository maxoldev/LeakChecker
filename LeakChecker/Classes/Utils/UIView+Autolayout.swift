//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

extension UIView {

    typealias SideContraints = (
        leading: NSLayoutConstraint?,
        top: NSLayoutConstraint?,
        trailing: NSLayoutConstraint?,
        bottom: NSLayoutConstraint?
    )

    typealias SizeContraints = (width: NSLayoutConstraint?, height: NSLayoutConstraint?)

    @discardableResult func pin(to view: UIView) -> SideContraints {
        translatesAutoresizingMaskIntoConstraints = false
        let leadingCs = pin(leadingAnchor, to: view.leadingAnchor, constant: 0)
        let topCs = pin(topAnchor, to: view.topAnchor, constant: 0)
        let trailingCs = pin(trailingAnchor, to: view.trailingAnchor, constant: 0)
        let bottomCs = pin(bottomAnchor, to: view.bottomAnchor, constant: 0)
        return (leadingCs, topCs, trailingCs, bottomCs)
    }

    @discardableResult func pin(
        to view: UIView,
        leading: CGFloat? = nil,
        top: CGFloat? = nil,
        trailing: CGFloat? = nil,
        bottom: CGFloat? = nil) -> SideContraints
    {
        translatesAutoresizingMaskIntoConstraints = false
        let leadingCs = pin(leadingAnchor, to: view.leadingAnchor, constant: leading)
        let topCs = pin(topAnchor, to: view.topAnchor, constant: top)
        let trailingCs = pin(trailingAnchor, to: view.trailingAnchor, constant: trailing)
        let bottomCs = pin(bottomAnchor, to: view.bottomAnchor, constant: bottom)
        return (leadingCs, topCs, trailingCs, bottomCs)
    }

    @discardableResult func set(width: CGFloat? = nil, height: CGFloat? = nil) -> SizeContraints {
        translatesAutoresizingMaskIntoConstraints = false
        var widthCs: NSLayoutConstraint?
        if let width = width {
            widthCs = widthAnchor.constraint(equalToConstant: width)
            widthCs?.isActive = true
        }
        var heightCs: NSLayoutConstraint?
        if let height = height {
            heightCs = heightAnchor.constraint(equalToConstant: height)
            heightCs?.isActive = true
        }
        return (widthCs, heightCs)
    }

    private func pin<T>(_ anchor1: NSLayoutAnchor<T>, to anchor2: NSLayoutAnchor<T>, constant: CGFloat?) -> NSLayoutConstraint? {
        guard let constant = constant else { return nil }
        
        let constraint = anchor1.constraint(equalTo: anchor2, constant: constant)
        constraint.isActive = true
        return constraint
    }

}
