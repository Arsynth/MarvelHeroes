//
// Created by Артем on 06/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol UITextFieldStyleApplicable {
    func apply(textFieldStyle: UITextFieldStyle)
}

extension UITextField: UITextFieldStyleApplicable {
    func apply(textFieldStyle: UITextFieldStyle) {
        textFieldStyle.apply(on: self)
    }
}

struct UITextFieldStyle: StyleSheet {
    typealias ObjectType = UITextField
    var viewStyle: UIViewStyle?
    var font: UIFont?
    var textColor: UIColor?
    var autocapitalizationType: UITextAutocapitalizationType?
    var autocorrectionType: UITextAutocorrectionType?

    init(viewStyle: UIViewStyle? = nil,
         font: UIFont? = nil,
         textColor: UIColor? = nil,
         autocapitalizationType: UITextAutocapitalizationType? = nil,
         autocorrectionType: UITextAutocorrectionType? = nil) {
        self.viewStyle = viewStyle
        self.font = font
        self.textColor = textColor
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
    }

    func apply(on object: UITextField) {
        viewStyle?.apply(on: object)
        if let font = font {
            object.font = font
        }
        if let textColor = textColor {
            object.textColor = textColor
        }
        if let autocapitalizationType = autocapitalizationType {
            object.autocapitalizationType = autocapitalizationType
        }
        if let autocorrectionType = autocorrectionType {
            object.autocorrectionType = autocorrectionType
        }
    }
}
