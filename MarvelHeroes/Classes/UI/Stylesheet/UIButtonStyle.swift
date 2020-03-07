//
// Created by Артем on 06/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

struct UIButtonStyle: StyleSheet {
    typealias ObjectType = UIButton

    public var viewStyle: UIViewStyle?
    public var contentEdgeInsets: UIEdgeInsets?
    public var imageEdgeInsets: UIEdgeInsets?
    public var titleEdgeInsets: UIEdgeInsets?
    public var contentHorizontalAlignment: UIButton.ContentHorizontalAlignment?
    public var contentVerticalAlignment: UIButton.ContentVerticalAlignment?

    private var labelStyleForState: [UIControl.State: UILabelStyle] = [:]
    private var backgroundImageForState: [UIControl.State: UIImage] = [:]
    private var titleColorForState: [UIControl.State: UIColor] = [:]

    init(withViewStyle viewStyle: UIViewStyle? = nil,
         contentEdgeInsets: UIEdgeInsets? = nil,
         imageEdgeInsets: UIEdgeInsets? = nil,
         titleEdgeInsets: UIEdgeInsets? = nil,
         contentHorizontalAlignment: UIButton.ContentHorizontalAlignment? = nil,
         contentVerticalAlignment: UIButton.ContentVerticalAlignment? = nil) {
        self.viewStyle = viewStyle
        self.imageEdgeInsets = imageEdgeInsets
        self.titleEdgeInsets = titleEdgeInsets
        self.contentHorizontalAlignment = contentHorizontalAlignment
        self.contentVerticalAlignment = contentVerticalAlignment
    }

    public mutating func setLabelStyle(_ style: UILabelStyle, forState state: UIControl.State = .normal) {
        labelStyleForState[state] = style
    }

    public mutating func setBackgroundImage(_ backgroundImage: UIImage, forState state: UIControl.State = .normal) {
        backgroundImageForState[state] = backgroundImage
    }

    public mutating func setTitleColor(_ titleColor: UIColor, forState state: UIControl.State = .normal) {
        titleColorForState[state] = titleColor
    }

    func apply(on object: UIButton) {
        viewStyle?.apply(on: object)

        if let contentEdgeInsets = contentEdgeInsets {
            object.contentEdgeInsets = contentEdgeInsets
        }
        if let imageEdgeInsets = imageEdgeInsets {
            object.imageEdgeInsets = imageEdgeInsets
        }
        if let titleEdgeInsets = titleEdgeInsets {
            object.titleEdgeInsets = titleEdgeInsets
        }
        for (state, style) in labelStyleForState {
            object.setTitleColor(style.textColor, for: state)
        }
        if let normalStateLabelStyle = labelStyleForState[.normal] {
            normalStateLabelStyle.apply(on: object.titleLabel!)
        }
        for (state, backgroundImage) in backgroundImageForState {
            object.setBackgroundImage(backgroundImage, for: state)
        }
        for (state, titleColor) in titleColorForState {
            object.setTitleColor(titleColor, for: state)
        }
        if let contentHorizontalAlignment = contentHorizontalAlignment {
            object.contentHorizontalAlignment = contentHorizontalAlignment
        }
        if let contentVerticalAlignment = contentVerticalAlignment {
            object.contentVerticalAlignment = contentVerticalAlignment
        }
    }
}

extension UIControl.State: Hashable {
    public var hashValue: Int {
        Int(rawValue)
    }
}