//
// Created by Артем on 08/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class CharacterListCellCommentPanel: UIView {
    private let titleLabel = UILabel()
    private let commentLabel = UILabel()
    private let button = UIButton(type: .system)
    private let dummyButton = UIButton()

    var didTapBlock: ()->() = {}

    var comment: String? {
        get {
            commentLabel.text
        } set {
            commentLabel.text = newValue
            titleLabel.isHidden = newValue == nil
            commentLabel.isHidden = newValue == nil
            button.isHidden = newValue != nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        Style.view.apply(on: self)
        addSubview(titleLabel)
        Style.titleLabel.apply(on: titleLabel)
        titleLabel.text = Resources.titleText
        addSubview(commentLabel)
        Style.commentLabel.apply(on: commentLabel)
        addSubview(button)
        Style.button.apply(on: button)
        button.setTitle(Resources.buttonText, for: .normal)
        button.addTarget(self, action: #selector(CharacterListCellCommentPanel.buttonDidTap), for: .touchUpInside)
        addSubview(dummyButton)
        dummyButton.addTarget(self, action: #selector(CharacterListCellCommentPanel.buttonDidTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if (commentLabel.text ?? "").count > 0 {
            let remainingWidth = bounds.size.width - Metrics.internalInsets.left - Metrics.internalInsets.right
            titleLabel.sizeToFit(withStaticWidth: remainingWidth)
            titleLabel.make(top: Metrics.internalInsets.top)
            titleLabel.make(left: Metrics.internalInsets.left)

            commentLabel.sizeToFit(withStaticWidth: remainingWidth)
            commentLabel.make(fromView: titleLabel, bottom: Metrics.commentLabelTop)
            commentLabel.make(left: Metrics.internalInsets.left)
            dummyButton.fillContainer()
        } else {
            button.fillContainer()
        }
    }

    @objc func buttonDidTap() {
        didTapBlock()
    }

    private class Style {
        static var view: UIViewStyle {
            UIViewStyle(backgroundColor: AppResources.Colors.crimson)
        }
        static var button: UIButtonStyle {
            var style = UIButtonStyle()
            style.setTitleColor(.white)
            style.setLabelStyle(UILabelStyle(font: .boldSystemFont(ofSize: 18), textColor: .white))
            return style
        }
        static var titleLabel: UILabelStyle {
            UILabelStyle(font: .boldSystemFont(ofSize: 14), textColor: .white, numberOfLines: 1)
        }
        static var commentLabel: UILabelStyle {
            UILabelStyle(font: .systemFont(ofSize: 14), textColor: .white, numberOfLines: 0)
        }
    }

    class Metrics {
        fileprivate static let internalInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        fileprivate static let commentLabelTop = CGFloat(8)
        public static let minHeight = CGFloat(44)

        public static func height(withComment comment: String?, maxWidth: CGFloat) -> CGFloat {
            guard let comment = comment else {
                return minHeight
            }

            let remainingWidth = maxWidth - internalInsets.left - internalInsets.right
            var height = internalInsets.top + internalInsets.bottom + commentLabelTop

            let titleLabelStyle = Style.titleLabel
            let attributedTitle = NSAttributedString(string: Resources.titleText, attributes: titleLabelStyle.asTextAttributes())
            let commentLabelStyle = Style.commentLabel
            let attributedComment = NSAttributedString(string: comment, attributes: commentLabelStyle.asTextAttributes())

            height += attributedTitle.fittingSize(
                    withSize: CGSize(width: remainingWidth, height: .greatestFiniteMagnitude),
                    numberOfLines: titleLabelStyle.numberOfLines ?? 0
            ).height
            height += attributedComment.fittingSize(
                    withSize: CGSize(width: remainingWidth, height: .greatestFiniteMagnitude),
                    numberOfLines: commentLabelStyle.numberOfLines ?? 0
            ).height

            return height
        }
    }

    private class Resources {
        static var titleText: String {
            "Your comment"
        }
        static var buttonText: String {
            "Put your comment"
        }
    }
}
