//
// Created by Артем on 07/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class CharacterListCollectionManager: NSObject {
    private let collectionView: UICollectionView
    private var characterListCancelable: Cancelable?
    private let pageCollector = ResponsePageCollector<Character>()
    private var isActive = false

    init(withCollectionView collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func activate() {
        isActive = true
        loadDataIfNeeded()
    }

    func loadDataIfNeeded() {
        guard characterListCancelable == nil,
              isActive == true,
               pageCollector.isDataExhausted == false else {
            return
        }
        characterListCancelable = MarvelAPIAdapter.shared.loadCharacters(offset: pageCollector.count) { [weak self] response in
            switch response {
            case .success(let result):
                self?.updateCollectionView(withPage: result)
            case .error(let message):
                print("OOPS! Error: \(message)")
            }
            self?.characterListCancelable = nil
        }
    }

    func updateCollectionView(withPage page: ResponsePage<Character>) {
        if pageCollector.count == 0 {
            pageCollector.putPage(page)
            collectionView.reloadData()
        } else {
            collectionView.performBatchUpdates({
                let oldCount = pageCollector.count
                pageCollector.putPage(page)
                let indexPaths = (oldCount..<pageCollector.count).map{ IndexPath(item: $0, section: 0)}
                collectionView.insertItems(at: indexPaths)
            }, completion: nil)
        }
    }
}

extension CharacterListCollectionManager: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.size.height >= scrollView.contentSize.height {
            loadDataIfNeeded()
        }
    }
}

extension CharacterListCollectionManager: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageCollector.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = pageCollector[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListCell.identifier, for: indexPath) as! CharacterListCell
        cell.configure(withCharacter: character)
        return cell
    }
}

extension CharacterListCollectionManager: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let character = pageCollector[indexPath.item]
        var size = CGSize(width: collectionView.frame.size.width, height: 0)
        size.height = CharacterListCell.Metrics.height(
                withMaxWidth: size.width,
                name: character.name,
                description: character.description
        )
        return size
    }
}