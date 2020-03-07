//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol UILabelStyleApplicable {
    func apply(labelStyle: UILabelStyle)
}

extension UILabel: UILabelStyleApplicable {
    func apply(labelStyle: UILabelStyle) {
        labelStyle.apply(on: self)
    }
}

struct UILabelStyle: StyleSheet {
    typealias ObjectType = UILabel
    public var viewStyle: UIViewStyle?
    public var font: UIFont?
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var numberOfLines: Int?
    public var adjustsFontSizeToFitWidth: Bool?
    public var minimumScaleFactor: CGFloat?
    public var baselineAdjustment: UIBaselineAdjustment?
    public var lineBreakMode: NSLineBreakMode?

    init(viewStyle: UIViewStyle? = nil,
         font: UIFont? = nil,
         textColor: UIColor? = nil,
         textAlignment: NSTextAlignment? = nil,
         numberOfLines: Int? = nil,
         adjustsFontSizeToFitWidth: Bool? = nil,
         minimumScaleFactor: CGFloat? = nil) {
        self.viewStyle = viewStyle
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor
    }

    func apply(on object: UILabel) {
        viewStyle?.apply(on: object)
        if let font = font {
            object.font = font
        }
        if let textColor = textColor {
            object.textColor = textColor
        }
        if let textAlignment = textAlignment {
            object.textAlignment = textAlignment
        }
        if let numberOfLines = numberOfLines {
            object.numberOfLines = numberOfLines
        }
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            object.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
        if let minimumScaleFactor = minimumScaleFactor {
            object.minimumScaleFactor = minimumScaleFactor
        }
        if let baselineAdjustment = baselineAdjustment {
            object.baselineAdjustment = baselineAdjustment
        }
        if let lineBreakMode = lineBreakMode {
            object.lineBreakMode = lineBreakMode
        }
    }
}

extension UILabelStyle {
    func asTextAttributes() -> [NSAttributedString.Key: Any] {
        [
            .foregroundColor: textColor ?? UIColor.black,
            .font: font ?? UIFont.systemFont(ofSize: 12)
        ]
    }
}