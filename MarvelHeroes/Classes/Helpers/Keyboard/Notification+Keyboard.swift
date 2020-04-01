//
// Created by Артем on 02/04/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import UIKit

extension Notification {

    func frameBeginKeyboard(notification: Notification) -> CGRect? {
        guard let value = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return nil
        }

        return value.cgRectValue
    }

    func frameEndKeyboard(notification: Notification) -> CGRect? {
        guard let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }

        return value.cgRectValue
    }

    func animationKeyboard(notification: Notification) -> UInt? {
        guard let value = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return nil
        }

        return value
    }

    func durationAnimationKeyboard(notification: Notification) -> Double? {
        guard let value = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue, let number = value as? NSNumber else {
            return nil
        }

        return number.doubleValue
    }

}
