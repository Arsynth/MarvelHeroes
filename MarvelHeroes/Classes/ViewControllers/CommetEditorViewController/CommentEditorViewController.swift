//
// Created by Артем on 08/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class CommentEditorViewController: UIViewController {
    let model: Model
    private var textView: UITextView!
    private var doneButton: UIButton!

    init(withModel model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = Resources.title
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Style.view.apply(on: view)

        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.text = model.character.comment
        Style.textView.apply(on: textView)
        textView.edge(constant: Metrics.internalInsets, anchorDirection: [.top, .horizontal])

        doneButton = UIButton(type: .system)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        doneButton.setTitle(Resources.doneTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(CommentEditorViewController.doneButtonTouchUp), for: .touchUpInside)
        AppResources.Stylesheet.defaultButton.apply(on: doneButton)
        doneButton.top(constant: Metrics.doneButtonTop, view: textView)
        doneButton.edge(constant: Metrics.internalInsets, anchorDirection: .horizontal)
        doneButton.bottomAccordingSafeArea(constant: Metrics.internalInsets.bottom, controller: self)
    }

    @objc func doneButtonTouchUp() {
        model.completionWithNewCommentBlock(textView.text)
    }

    class Model {
        let character: Character
        let completionWithNewCommentBlock: (String)->()

        init(withCharacter character: Character, completionWithNewComment: @escaping (String)->()) {
            self.character = character
            self.completionWithNewCommentBlock = completionWithNewComment
        }
    }

    fileprivate class Resources {
        static var title: String {
            "Comment"
        }
        static var doneTitle: String {
            "Done"
        }
    }

    fileprivate class Metrics {
        static let internalInsets = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        static let doneButtonTop = CGFloat(10)
    }

    fileprivate class Style {
        static var view: UIViewStyle {
            UIViewStyle(backgroundColor: AppResources.Colors.dark)
        }
        static var textView: UIViewStyle {
            UIViewStyle(borderColor: AppResources.Colors.gray, borderWidth: 1/UIScreen.main.scale)
        }
    }
}
