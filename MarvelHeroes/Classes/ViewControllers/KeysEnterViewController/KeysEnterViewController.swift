//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Артем on 04/03/2020.
//  Copyright © 2020 Артем. All rights reserved.
//

import UIKit


class KeysEnterViewController: UIViewController {
    private var privateKeyTextField: UITextField!
    private var publicKeyTextField: UITextField!

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = Resources.title
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        Style.view.apply(on: view)

        let privateKeyTitleLabel = UILabel()
        privateKeyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        privateKeyTitleLabel.text = Resources.privateKeyTitle
        view.addSubview(privateKeyTitleLabel)
        Style.labels.apply(on: privateKeyTitleLabel)
        privateKeyTitleLabel.topAccordingSafeArea(constant: Metrics.internalInsets.top, controller: self)
        privateKeyTitleLabel.edge(constant: Metrics.internalInsets, anchorDirection: .horizontal)

        privateKeyTextField = UITextField()
        privateKeyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(privateKeyTextField)
        privateKeyTextField.text = DebugKeyStoreManager.shared.privateKey
        Style.textFields.apply(on: privateKeyTextField)
        privateKeyTextField.top(constant: Metrics.textFieldTop, view: privateKeyTitleLabel)
        privateKeyTextField.edge(constant: Metrics.internalInsets, anchorDirection: .horizontal)

        let publicKeyTitleLabel = UILabel()
        publicKeyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        publicKeyTitleLabel.text = Resources.publicKeyTitle
        view.addSubview(publicKeyTitleLabel)
        Style.labels.apply(on: publicKeyTitleLabel)
        publicKeyTitleLabel.top(constant: Metrics.inputGroupsOffset, view: privateKeyTextField)
        publicKeyTitleLabel.edge(constant: Metrics.internalInsets, anchorDirection: .horizontal)

        publicKeyTextField = UITextField()
        publicKeyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(publicKeyTextField)
        publicKeyTextField.text = DebugKeyStoreManager.shared.publicKey
        Style.textFields.apply(on: publicKeyTextField)
        publicKeyTextField.top(constant: Metrics.textFieldTop, view: publicKeyTitleLabel)
        publicKeyTextField.edge(constant: Metrics.internalInsets, anchorDirection: .horizontal)

        let nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        Style.nextButton.apply(on: nextButton)
        nextButton.setTitle(Resources.nextButtonTitle, for: .normal)
        nextButton.addTarget(self, action: #selector(KeysEnterViewController.nextButtonTouchUp), for: .touchUpInside)
        nextButton.top(constant: Metrics.nextButtonTop, view: publicKeyTextField)
        nextButton.left(constant: Metrics.internalInsets.left)
    }

    @objc private func nextButtonTouchUp() {
        DebugKeyStoreManager.shared.privateKey = privateKeyTextField.text
        DebugKeyStoreManager.shared.publicKey = publicKeyTextField.text

        navigationController?.pushViewController(CharacterListViewController(), animated: true)
    }

    private class Resources {
        static var title: String {
            "Authorization"
        }
        static var privateKeyTitle: String {
            "Private key"
        }
        static var publicKeyTitle: String {
            "Public key"
        }
        static var nextButtonTitle: String {
            "Next"
        }
    }

    private class Metrics {
        static let internalInsets = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        static let textFieldTop = CGFloat(8)
        static let inputGroupsOffset = CGFloat(12)
        static let nextButtonTop = CGFloat(16)
    }

    private class Style {
        static var view: UIViewStyle {
            UIViewStyle(backgroundColor: .white)
        }
        static var labels: UILabelStyle {
            UILabelStyle(font: .systemFont(ofSize: 14))
        }
        static var textFields: UITextFieldStyle {
            UITextFieldStyle(
                    viewStyle: UIViewStyle(
                            withTintColor: AppResources.Colors.crimson, backgroundColor: .white,
                            borderColor: AppResources.Colors.gray,
                            borderWidth: 1/UIScreen.main.scale
                    ),
                    autocapitalizationType: UITextAutocapitalizationType.none,
                    autocorrectionType: .no
            )
        }
        static var nextButton: UIButtonStyle {
            UIButtonStyle(withViewStyle: UIViewStyle(withTintColor: AppResources.Colors.crimson))
        }
    }
}
