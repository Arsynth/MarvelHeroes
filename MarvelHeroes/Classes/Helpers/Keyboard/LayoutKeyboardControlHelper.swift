//
// Created by Артем on 02/04/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class LayoutKeyboardControlHelper: KeyboardControlHelper {
    private var defaultConstant: CGFloat = 0

    private var showKeyboard = false

    override var isEnable: Bool {
        didSet {
            guard let layout = layout else {
                return
            }
            layout.constant = defaultConstant
        }
    }

    @IBOutlet weak var layout: NSLayoutConstraint! {
        didSet {
            defaultConstant = layout.constant
            if isEnable {
                layout.constant = defaultConstant
            }
        }
    }
    private weak var container: UIView?

    var disableAnimation: Bool = false

    init(container: UIView? = nil) {
        self.container = container
    }

    override func keyboardWillShow(notification: Notification) {
        defer {
            self.showKeyboard = true
        }

        guard self.showKeyboard == false else {
            return
        }

        adjustKeyboardFrame(notification: notification)
    }

    override func keyboardWillChangeFrame(notification: Notification) {
        let screenHeight = UIScreen.main.bounds.size.height
        let constant = screenHeight - notification.frameEndKeyboard(notification: notification)!.origin.y
        self.layout.constant = constant + defaultConstant
    }

    override func keyboardWillHide(notification:Notification) {
        defer {
            self.showKeyboard = false
        }

        guard self.showKeyboard == true else {
            return
        }

        adjustKeyboardFrame(notification: notification)
    }

    private func adjustKeyboardFrame(notification: Notification) {
        let screenHeight = UIScreen.main.bounds.size.height
        let frameBeginKeyboard = notification.frameBeginKeyboard(notification: notification)
        let frameEndKeyboard = notification.frameEndKeyboard(notification: notification)
        let constant = screenHeight - frameEndKeyboard!.origin.y + defaultConstant
        let needAnimation = (frameBeginKeyboard != frameEndKeyboard) && UIView.areAnimationsEnabled && !self.disableAnimation

        animation(constant: constant, notification: notification, needAnimation: needAnimation)
    }

    private func animation(constant: CGFloat, notification: Notification, needAnimation: Bool) {

        let layoutBlock = {
            self.layout.constant = constant
            self.container?.layoutIfNeeded()
        }

        if needAnimation {
            guard let animation = notification.animationKeyboard(notification: notification),
                  let duration = notification.durationAnimationKeyboard(notification: notification) else {
                return
            }

            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: animation << 16), animations: {
                layoutBlock()
            })
        } else {
            UIView.performWithoutAnimation {
                layoutBlock()
            }
        }
    }
}
