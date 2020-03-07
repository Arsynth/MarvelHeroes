//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class CharacterListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var collectionManager: CharacterListCollectionManager!

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
        Style.backgroundView.apply(on: view)

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.edge()
        collectionView.backgroundColor = .clear
        collectionView.register(CharacterListCell.self, forCellWithReuseIdentifier: CharacterListCell.identifier)
        collectionManager = CharacterListCollectionManager(withCollectionView: collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionManager.activate()
    }

    private class Resources {
        static var title: String {
            "Characters"
        }
    }

    private class Style {
        static var backgroundView: UIViewStyle {
            UIViewStyle(backgroundColor: .white)
        }
    }

    private class Metrics {

    }
}