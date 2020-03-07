//
// Created by Артем on 04/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIView {

    @discardableResult func make(size: CGSize) -> UIView {
        var frame = self.frame;
        frame.size = size;
        self.frame = frame;

        return self;
    }

    @discardableResult func makeCenterX(round: Bool = true) -> UIView {
        var center = self.center
        center.x = superview!.bounds.size.width / 2.0
        self.center = center

        if round {
            self.roundFrameOffsets()
        }

        return self
    }

    @discardableResult func makeCenterY(round: Bool = true) -> UIView {
        var center = self.center
        center.y = superview!.bounds.size.height / 2.0
        self.center = center

        if round {
            self.roundFrameOffsets()
        }

        return self
    }

    @discardableResult func makeCenter(round: Bool = true) -> UIView {
        var center = self.center
        center.x = superview!.bounds.size.width / 2.0
        center.y = superview!.bounds.size.height / 2.0
        self.center = center

        if round {
            self.roundFrameOffsets()
        }

        return self
    }

    @discardableResult func make(edgeInsets: UIEdgeInsets) -> UIView {
        frame = frame.inset(by: edgeInsets)
        return self
    }

    @discardableResult func makeEdgeInset(left: CGFloat, right: CGFloat) -> UIView {
        let superviewFrame = superview!.bounds
        var finalFrame = frame

        finalFrame.origin.x = left
        finalFrame.size.width = superviewFrame.size.width - (left + right)

        frame = finalFrame

        return self
    }

    @discardableResult func makeEdgeInset(top: CGFloat, bottom: CGFloat) -> UIView {
        let superviewFrame = superview!.bounds
        var finalFrame = frame

        finalFrame.origin.y = top
        finalFrame.size.height = superviewFrame.size.height - (top + bottom)

        frame = finalFrame

        return self
    }

    @discardableResult func makeEdgeInset(top: CGFloat, bottom: CGFloat, minHeight: CGFloat = 0) -> UIView {
        let superviewFrame = superview!.bounds
        var finalFrame = frame

        finalFrame.origin.y = top
        finalFrame.size.height = max(superviewFrame.size.height - (top + bottom), minHeight)

        frame = finalFrame

        return self
    }

    @discardableResult func makeCurrentFrame(insets: UIEdgeInsets) -> UIView {
        frame.inset(by: insets)
        return self
    }

    @discardableResult func makeCurrentFrame(inset: CGFloat) -> UIView {
        makeCurrentFrame(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    @discardableResult func fillContainer() -> UIView {
        frame = superview!.bounds
        return self
    }

    @discardableResult func make(top: CGFloat) -> UIView {
        var frame = self.frame
        frame.origin.y = top
        self.frame = frame
        return self
    }

    @discardableResult func make(left: CGFloat) -> UIView {
        var frame = self.frame
        frame.origin.x = left
        self.frame = frame
        return self
    }

    @discardableResult func make(topLeft: CGPoint) -> UIView {
        make(top: topLeft.y)
        make(left: topLeft.x)
        return self
    }

    @discardableResult func make(topLeft: UIEdgeInsets) -> UIView {
        make(top: topLeft.top)
        make(left: topLeft.left)
        return self
    }

    @discardableResult func make(right: CGFloat) -> UIView {
        make(left: superview!.bounds.size.width - frame.size.width - right)
    }

    @discardableResult func make(topRight: CGPoint) -> UIView {
        make(top: topRight.y)
        make(right: topRight.x)
        return self
    }

    @discardableResult func make(bottom: CGFloat) -> UIView {
        make(top: superview!.bounds.size.height - frame.size.height - bottom)
    }

    @discardableResult func make(rightBottom: CGPoint) -> UIView {
        make(right: rightBottom.x)
        make(bottom: rightBottom.y)
        return self
    }

    @discardableResult func make(leftBottom: CGPoint) -> UIView {
        make(left: leftBottom.x)
        make(bottom: leftBottom.y)
        return self
    }

    @discardableResult func make(fromView view: UIView, top offset: CGFloat) -> UIView {
        make(bottom: view.getTop() - offset)
    }

    @discardableResult func make(fromView view: UIView, left offset: CGFloat) -> UIView {
        make(right: superview!.bounds.size.width - view.getLeft() + offset)
    }

    @discardableResult func make(fromView view: UIView, right offset: CGFloat) -> UIView {
        make(left: view.getRight() + offset)
    }

    @discardableResult func make(fromView view: UIView, bottom offset: CGFloat) -> UIView {
        make(top: view.getBottom() + offset)
    }

    @discardableResult func make(width: CGFloat) -> UIView {
        var frame = self.frame

        frame.size.width = width
        self.frame = frame

        return self
    }

    @discardableResult func make(height: CGFloat) -> UIView {
        var frame = self.frame

        frame.size.height = height
        self.frame = frame

        return self
    }

    @discardableResult func make(centerX: CGFloat) -> UIView {
        var center = self.center
        center.x = centerX
        self.center = center
        roundFrameOffsets()
        return self
    }

    @discardableResult func make(centerY: CGFloat) -> UIView {
        var center = self.center
        center.y = centerY
        self.center = center
        roundFrameOffsets()
        return self
    }

    @discardableResult func make(center: CGPoint) -> UIView {
        make(centerX: center.x)
        make(centerY: center.y)
        return self
    }

    @discardableResult func sizeToFit(withStaticHeight staticHeight: CGFloat, maxWidth: CGFloat = .greatestFiniteMagnitude) -> UIView {
        var fitSize = sizeThatFits(CGSize(width: maxWidth, height: staticHeight))
        fitSize.height = staticHeight
        fitSize.width = min(fitSize.width, maxWidth)
        return make(size: fitSize)
    }

    @discardableResult func sizeToFit(withStaticWidth staticWidth: CGFloat, maxHeight: CGFloat = .greatestFiniteMagnitude) -> UIView {
        var fitSize = sizeThatFits(CGSize(width: staticWidth, height: maxHeight))
        fitSize.width = staticWidth
        fitSize.height = min(fitSize.height, maxHeight)
        return make(size: fitSize)
    }

    func getTop() -> CGFloat {
        frame.origin.y
    }

    func getLeft() -> CGFloat {
        frame.origin.x
    }

    func getBottom() -> CGFloat {
        frame.origin.y + frame.size.height
    }

    func getRight() -> CGFloat {
        frame.origin.x + frame.size.width
    }

    func getWidth() -> CGFloat {
        frame.size.width
    }

    func getHeight() -> CGFloat {
        frame.size.height
    }

    func getTopLeft() -> CGPoint {
        CGPoint(x: getLeft(), y: getTop())
    }

    func getBottomRight() -> CGPoint {
        CGPoint(x: getRight(), y: getBottom())
    }

    func roundFrameOffsets() {
        var frame = self.frame
        frame.origin.x = frame.origin.x.rounded(.up)
        frame.origin.y = frame.origin.y.rounded(.up)
        self.frame = frame
    }

    static func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11, *) {
            if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window as? UIWindow {
                return window.safeAreaInsets
            } else {
                return .zero
            }
        } else {
            return .zero
        }
    }

    static func makeVerticalCenterForGroup(views: [UIView], top: CGFloat, indents: CGFloat) {
        var currentOffset = top
        views.forEach { view in
            view.make(top: currentOffset)
            currentOffset = view.getBottom() + indents
        }
    }

    static func makeVerticalCenterForGroup(views: [UIView], center: CGFloat, indents: CGFloat) {
        var groupHeight: CGFloat = 0.0
        views.forEach { view in
            groupHeight += view.getHeight()
            groupHeight += indents
        }

        groupHeight -= indents

        var currentOffset = (center - groupHeight / 2.0).rounded()
        views.forEach { view in
            view.make(top: currentOffset)
            currentOffset = view.getBottom() + indents
        }
    }
}
