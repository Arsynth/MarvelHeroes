//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewStyleApplicable {
    func apply(viewStyle: UIViewStyle)
}

extension UIView: UIViewStyleApplicable {
    func apply(viewStyle: UIViewStyle) {
        viewStyle.apply(on: self)
    }
}

struct UIViewStyle: StyleSheet {
    typealias ObjectType = UIView

    public var tintColor: UIColor?
    public var backgroundColor: UIColor?
    public var cornerRadius: CGFloat?
    public var borderColor: UIColor?
    public var borderWidth: CGFloat?
    public var contentMode: UIView.ContentMode?

    public init(withTintColor tintColor: UIColor? = nil,
                backgroundColor: UIColor? = nil,
                cornerRadius: CGFloat? = nil,
                borderColor: UIColor? = nil,
                borderWidth: CGFloat? = nil,
                contentMode: UIView.ContentMode? = nil) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.contentMode = contentMode
    }

    func apply(on object: UIView) {
        if let tintColor = tintColor {
            object.tintColor = tintColor
        }
        if let backgroundColor = backgroundColor {
            object.backgroundColor = backgroundColor
        }
        if let cornerRadius = cornerRadius {
            object.layer.cornerRadius = cornerRadius
        }
        if let borderColor = borderColor {
            object.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            object.layer.borderWidth = borderWidth
        }
        if let contentMode = contentMode {
            object.contentMode = contentMode
        }
    }
}