//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

import UIKit

enum ConstraintEquality<AnchorType:AnyObject> {
    case equal(priority: UILayoutPriority)
    case greaterThanOrEqualTo(priority: UILayoutPriority)
    case lessThanOrEqualTo(priority: UILayoutPriority)

    public static func defaultEqual() -> ConstraintEquality {
        .equal(priority: .required)
    }

    public static func defaultGreaterThanOrEqualTo() -> ConstraintEquality {
        .greaterThanOrEqualTo(priority: .required)
    }

    public static func defaultLessThanOrEqualTo() -> ConstraintEquality {
        .lessThanOrEqualTo(priority: .required)
    }

    func constraintFor(lhs: NSLayoutAnchor<AnchorType>, rhs: NSLayoutAnchor<AnchorType>, constant: CGFloat = UIView.defaultConstant) -> NSLayoutConstraint {
        switch self {
        case let .equal(priority):
            let constraint = lhs.constraint(equalTo: rhs, constant: constant)
            constraint.priority = priority
            return constraint
        case let .greaterThanOrEqualTo(priority):
            let constraint = lhs.constraint(greaterThanOrEqualTo: rhs, constant: constant)
            constraint.priority = priority
            return constraint
        case let .lessThanOrEqualTo(priority):
            let constraint = lhs.constraint(lessThanOrEqualTo: rhs, constant: constant)
            constraint.priority = priority
            return constraint
        }
    }
}

extension ConstraintEquality where AnchorType == NSLayoutDimension {

    func constraintDimensionFor(lhs: NSLayoutDimension, rhs: NSLayoutDimension,
                                multiplier: CGFloat = UIView.defaultMultiplier, constant: CGFloat = UIView.defaultConstant) -> NSLayoutConstraint {
        switch self {
        case let .equal(priority):
            let constraint = lhs.constraint(equalTo: rhs, multiplier: multiplier, constant: constant)
            constraint.priority = priority
            return constraint
        case let .greaterThanOrEqualTo(priority):
            let constraint = lhs.constraint(greaterThanOrEqualTo: rhs, multiplier: multiplier, constant: constant)
            constraint.priority = priority
            return constraint
        case let .lessThanOrEqualTo(priority):
            let constraint = lhs.constraint(lessThanOrEqualTo: rhs, multiplier: multiplier, constant: constant)
            constraint.priority = priority
            return constraint
        }
    }

    func constraintDimensionFor(laoyut: NSLayoutDimension, constant: CGFloat = UIView.defaultConstant) -> NSLayoutConstraint {
        switch self {
        case let .equal(priority):
            let constraint = laoyut.constraint(equalToConstant: constant)
            constraint.priority = priority
            return constraint
        case let .greaterThanOrEqualTo(priority):
            let constraint = laoyut.constraint(greaterThanOrEqualToConstant: constant)
            constraint.priority = priority
            return constraint
        case let .lessThanOrEqualTo(priority):
            let constraint = laoyut.constraint(lessThanOrEqualToConstant: constant)
            constraint.priority = priority
            return constraint
        }
    }

}

extension UIView {

    struct AnchorConstraintDirection: OptionSet {
        let rawValue: UInt8

        static let top = AnchorConstraintDirection(rawValue: 1 << 0)
        static let bottom = AnchorConstraintDirection(rawValue: 1 << 1)
        static let left = AnchorConstraintDirection(rawValue: 1 << 2)
        static let right = AnchorConstraintDirection(rawValue: 1 << 3)
        static let horizontal = AnchorConstraintDirection([.left, right])
        static let vertical = AnchorConstraintDirection([.top, bottom])
        static let all = AnchorConstraintDirection([.top, .bottom, .left, right])
    }

    fileprivate static let defaultConstant = CGFloat(0)
    fileprivate static let defaultMultiplier = CGFloat(1)
    fileprivate static let defaultEdgeInsets = UIEdgeInsets.zero
    fileprivate static let defaultAnchorConstraintDirection = AnchorConstraintDirection.all
    fileprivate static let defaultConstraintEqualityForX = ConstraintEquality<NSLayoutXAxisAnchor>.defaultEqual()
    fileprivate static let defaultConstraintEqualityForY = ConstraintEquality<NSLayoutYAxisAnchor>.defaultEqual()
    fileprivate static let defaultConstraintEqualityForSize = ConstraintEquality<NSLayoutDimension>.defaultEqual()

    @discardableResult func topAccordingSafeArea(constant: CGFloat = UIView.defaultConstant, controller: UIViewController) -> NSLayoutConstraint {
        if #available(iOS 11, *) {
            let guide = controller.view.safeAreaLayoutGuide
            let constraint = self.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0)
            constraint.isActive = true
            return constraint
        } else {
            let bottomAnchor = controller.topLayoutGuide.bottomAnchor
            let constraint = self.topAnchor.constraint(equalTo: bottomAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        }
    }

    @discardableResult func bottomAccordingSafeArea(constant: CGFloat = UIView.defaultConstant, controller: UIViewController) -> NSLayoutConstraint {
        if #available(iOS 11, *) {
            let guide = controller.view.safeAreaLayoutGuide
            let constraint = self.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0)
            constraint.isActive = true
            return constraint
        } else {
            let topAnchor = controller.bottomLayoutGuide.topAnchor
            let constraint = self.bottomAnchor.constraint(equalTo: topAnchor, constant: -constant)
            constraint.isActive = true
            return constraint
        }
    }

    @discardableResult func spaceNavigationBar(constant: CGFloat = UIView.defaultConstant, controller: UIViewController) -> NSLayoutConstraint {
        if #available(iOS 11, *) {
            let guide = controller.view.safeAreaLayoutGuide
            let constraint = self.topAnchor.constraint(equalTo: guide.topAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        } else {
            let bottomAnchor = controller.topLayoutGuide.bottomAnchor
            let constraint = self.topAnchor.constraint(equalTo: bottomAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        }
    }

    @discardableResult func spaceBottomBar(constant: CGFloat = UIView.defaultConstant, controller: UIViewController) -> NSLayoutConstraint {
        if #available(iOS 11, *) {
            let guide = controller.view.safeAreaLayoutGuide
            let constraint = self.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        } else {
            let bottomAnchor = controller.bottomLayoutGuide.bottomAnchor
            let constraint = self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant)
            constraint.isActive = true
            return constraint
        }
    }

    @discardableResult func topAnchorTop(constant: CGFloat = UIView.defaultConstant, anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.topAnchor.constraint(equalTo: anchorView.topAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func bottomAnchorBottom(constant: CGFloat = UIView.defaultConstant, anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.bottomAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func leftAnchorLeft(constant: CGFloat = UIView.defaultConstant, anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.leftAnchor.constraint(equalTo: anchorView.leftAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func rightAnchorRight(constant: CGFloat = UIView.defaultConstant, anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.rightAnchor.constraint(equalTo: anchorView.rightAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func bottomAnchorLastBaselineAnchor(constant: CGFloat = UIView.defaultConstant, anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.bottomAnchor.constraint(equalTo: anchorView.lastBaselineAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func firstBaselineAnchorAnchorFirstBaselineAnchor(constant: CGFloat = UIView.defaultConstant,
                                                                         anchorView: UIView) -> NSLayoutConstraint {
        let constraint = self.firstBaselineAnchor.constraint(equalTo: anchorView.firstBaselineAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func top(constant: CGFloat = UIView.defaultConstant,
                                view: UIView? = nil,
                                equality: ConstraintEquality<NSLayoutYAxisAnchor> = UIView.defaultConstraintEqualityForY) -> NSLayoutConstraint {
        let anchorView = getAnchorView(view: view)
        let rightHandAnchor = anchorView == view ?
                anchorView.bottomAnchor :
                anchorView.topAnchor
        let constraint = equality.constraintFor(lhs: topAnchor, rhs: rightHandAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func left(constant: CGFloat = UIView.defaultConstant,
                                 view: UIView? = nil,
                                 equality: ConstraintEquality<NSLayoutXAxisAnchor> = UIView.defaultConstraintEqualityForX) -> NSLayoutConstraint {
        let anchorView = getAnchorView(view: view)
        let rightHandAnchor = anchorView == view ?
                anchorView.rightAnchor :
                anchorView.leftAnchor
        let constraint = equality.constraintFor(lhs: leftAnchor, rhs: rightHandAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func right(constant: CGFloat = UIView.defaultConstant,
                                  view: UIView? = nil,
                                  equality: ConstraintEquality<NSLayoutXAxisAnchor> = UIView.defaultConstraintEqualityForX) -> NSLayoutConstraint {
        let anchorView = getAnchorView(view: view)
        let rightHandAnchor = anchorView == view ?
                anchorView.leftAnchor :
                anchorView.rightAnchor
        let constraint = equality.constraintFor(lhs: rightHandAnchor, rhs: rightAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func bottom(constant: CGFloat = UIView.defaultConstant,
                                   view: UIView? = nil,
                                   equality: ConstraintEquality<NSLayoutYAxisAnchor> = UIView.defaultConstraintEqualityForY) -> NSLayoutConstraint {
        let anchorView = getAnchorView(view: view)
        let rightHandAnchor = anchorView == view ?
                anchorView.topAnchor :
                anchorView.bottomAnchor
        let constraint = equality.constraintFor(lhs: rightHandAnchor, rhs: bottomAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func width(constant: CGFloat = UIView.defaultConstant, multiplier: CGFloat = UIView.defaultMultiplier, view: UIView? = nil, equality: ConstraintEquality<NSLayoutDimension> = UIView.defaultConstraintEqualityForSize) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        defer {
            constraint.isActive = true
        }
        if let view = view {
            constraint = equality.constraintDimensionFor(lhs: self.widthAnchor, rhs: view.widthAnchor, multiplier: multiplier, constant: constant)
        } else {
            constraint = equality.constraintDimensionFor(laoyut: self.widthAnchor, constant: constant)
        }
        return constraint
    }

    @discardableResult func height(constant: CGFloat = UIView.defaultConstant, multiplier: CGFloat = UIView.defaultMultiplier, view: UIView? = nil, equality: ConstraintEquality<NSLayoutDimension> = UIView.defaultConstraintEqualityForSize) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        defer {
            constraint.isActive = true
        }
        if let view = view {
            constraint = equality.constraintDimensionFor(lhs: self.heightAnchor, rhs: view.heightAnchor, multiplier: multiplier, constant: constant)
        } else {
            constraint = equality.constraintDimensionFor(laoyut: self.heightAnchor, constant: constant)
        }
        return constraint
    }

    @discardableResult func ratioHeightToWidth(constant: CGFloat = UIView.defaultConstant, multiplier: CGFloat = UIView.defaultMultiplier, view: UIView? = nil, equality: ConstraintEquality<NSLayoutDimension> = UIView.defaultConstraintEqualityForSize) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        defer {
            constraint.isActive = true
        }
        let rightHandAnchor = view == nil ?
                self.widthAnchor :
                view!.widthAnchor
        constraint = equality.constraintDimensionFor(lhs: self.heightAnchor, rhs: rightHandAnchor, multiplier: multiplier, constant: constant)
        return constraint
    }

    @discardableResult func ratioWidthToHeight(constant: CGFloat = UIView.defaultConstant, multiplier: CGFloat = UIView.defaultMultiplier, view: UIView? = nil, equality: ConstraintEquality<NSLayoutDimension> = UIView.defaultConstraintEqualityForSize) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint!
        defer {
            constraint.isActive = true
        }
        let rightHandAnchor = view == nil ?
                self.heightAnchor :
                view!.heightAnchor
        constraint = equality.constraintDimensionFor(lhs: self.widthAnchor, rhs: rightHandAnchor, multiplier: multiplier, constant: constant)
        return constraint
    }

    @discardableResult func centerX(constant: CGFloat = UIView.defaultConstant, view: UIView? = nil) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: getAnchorView(view: view).centerXAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func centerY(constant: CGFloat = UIView.defaultConstant, view: UIView? = nil, anchorDirection: AnchorConstraintDirection? = nil) -> NSLayoutConstraint {
        let anchorView = getAnchorView(view: view)
        var layoutAnchor: NSLayoutYAxisAnchor!
        if let anchorDirection = anchorDirection {
            if anchorDirection.contains(.top) {
                layoutAnchor = anchorView.topAnchor
            }
            else
            if anchorDirection.contains(.bottom) {
                layoutAnchor = anchorView.bottomAnchor
            }
        } else {
            layoutAnchor = anchorView.centerYAnchor
        }
        let constraint = self.centerYAnchor.constraint(equalTo: layoutAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func centerYToBottom(constant: CGFloat = UIView.defaultConstant, view: UIView? = nil) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: getAnchorView(view: view).bottomAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult func centerYToTop(constant: CGFloat = UIView.defaultConstant, view: UIView? = nil) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: getAnchorView(view: view).topAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }

    func edge(constant: UIEdgeInsets = UIView.defaultEdgeInsets,
              anchorDirection: AnchorConstraintDirection = UIView.defaultAnchorConstraintDirection,
              view: UIView? = nil) {
        if anchorDirection.contains(.top) {
            top(constant: constant.top, view: view)
        }
        if anchorDirection.contains(.left) {
            left(constant: constant.left, view: view)
        }
        if anchorDirection.contains(.right) {
            right(constant: constant.right, view: view)
        }
        if anchorDirection.contains(.bottom) {
            bottom(constant: constant.bottom, view: view)
        }
    }

    private func getAnchorView(view: UIView?) -> UIView {
        if let view = view {
            return view
        }
        guard let superview = self.superview else {
            fatalError("View doesn't have a superview")
        }
        return superview
    }

}
