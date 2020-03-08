//
// Created by Артем on 07/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class CharacterListCell: UICollectionViewCell {
    static let identifier = "cellId"
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let commentPanel = CharacterListCellCommentPanel()

    var commentDidTapBlock: ()->() = {}

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(iconView)

        contentView.addSubview(nameLabel)
        Style.nameLabel.apply(on: nameLabel)
        contentView.addSubview(descriptionLabel)
        Style.descriptionLabel.apply(on: descriptionLabel)
        contentView.addSubview(commentPanel)
        commentPanel.didTapBlock = { [weak self] in
            self?.commentDidTapBlock()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        iconView.make(size: Metrics.iconViewSize)
        iconView.make(top: Metrics.internalInsets.top)
        iconView.make(left: Metrics.internalInsets.left)

        let remainingWidth = bounds.size.width -
                Metrics.internalInsets.left -
                Metrics.internalInsets.right -
                Metrics.iconViewSize.width -
                Metrics.labelsLeft

        nameLabel.sizeToFit(withStaticWidth: remainingWidth)
        nameLabel.make(top: Metrics.internalInsets.top)
        nameLabel.make(fromView: iconView, right: Metrics.labelsLeft)

        descriptionLabel.sizeToFit(withStaticWidth: remainingWidth)
        descriptionLabel.make(fromView: nameLabel, bottom: Metrics.descriptionLabelTop)
        descriptionLabel.make(fromView: iconView, right: Metrics.labelsLeft)

        commentPanel.make(width: bounds.size.width)
        commentPanel.make(height: CharacterListCellCommentPanel.Metrics.height(withComment: commentPanel.comment, maxWidth: commentPanel.getWidth()))
        commentPanel.make(bottom: 0)
    }

    public func configure(withCharacter character: Character) {
        if let imageURL = character.thumbnailURL {
            iconView.setImageWith(imageURL)
        } else {
            iconView.cancelImageDownloadTask()
            iconView.image = nil
        }

        nameLabel.text = character.name
        descriptionLabel.text = character.description
        commentPanel.comment = character.comment
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.cancelImageDownloadTask()
        iconView.image = nil
    }

    private class Style {
        static var nameLabel: UILabelStyle {
            UILabelStyle(font: .boldSystemFont(ofSize: 14), numberOfLines: 1)
        }
        static var descriptionLabel: UILabelStyle {
            UILabelStyle(font: .systemFont(ofSize: 14), numberOfLines: 3)
        }
    }

    class Metrics {
        fileprivate static let internalInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        fileprivate static let iconViewSize = CGSize(width: 65, height: 45)
        fileprivate static let descriptionLabelTop = CGFloat(8)
        fileprivate static let labelsLeft = CGFloat(8)

        public static func height(withCharacter character: Character, maxWidth: CGFloat) -> CGFloat {
            let remainingWidth = maxWidth -
                    internalInsets.left -
                    internalInsets.right -
                    iconViewSize.width -
                    labelsLeft
            let minHeight = iconViewSize.height + internalInsets.top + internalInsets.bottom
            var height = internalInsets.top + internalInsets.bottom + descriptionLabelTop

            let nameLabelStyle = Style.nameLabel
            let attributedName = NSAttributedString(string: character.name, attributes: nameLabelStyle.asTextAttributes())
            let descriptionLabelStyle = Style.descriptionLabel
            let attributedDescription = NSAttributedString(string: character.description, attributes: descriptionLabelStyle.asTextAttributes())

            height += attributedName.fittingSize(
                    withSize: CGSize(width: remainingWidth, height: .greatestFiniteMagnitude),
                    numberOfLines: nameLabelStyle.numberOfLines ?? 0
            ).height
            height += attributedDescription.fittingSize(
                    withSize: CGSize(width: remainingWidth, height: .greatestFiniteMagnitude),
                    numberOfLines: descriptionLabelStyle.numberOfLines ?? 0
            ).height
            let commentPanelHeight = CharacterListCellCommentPanel.Metrics.height(withComment: character.comment, maxWidth: maxWidth)
            height += commentPanelHeight

            return max(minHeight + commentPanelHeight, height)
        }
    }
}
