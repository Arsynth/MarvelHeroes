//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class AppResources {
    class Colors {
        static var dark: UIColor {
            UIColor(white: 32/255, alpha: 1)
        }

        static var gray: UIColor {
            UIColor(white: 204/255, alpha: 1)
        }

        static var crimson: UIColor {
            UIColor(red: 241/255, green: 21/255, blue: 43/255, alpha: 1.0)
        }
    }

    class Stylesheet {
        static var defaultButton: UIButtonStyle {
            var style = UIButtonStyle()
            style.viewStyle = UIViewStyle(backgroundColor: AppResources.Colors.crimson)
            style.setTitleColor(.white)
            style.setLabelStyle(UILabelStyle(font: .boldSystemFont(ofSize: 18), textColor: .white))
            style.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
            return style
        }
    }
}