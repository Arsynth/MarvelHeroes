//
// Created by Артем on 07/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterListCollectionManagerDelegate {
    func collectionManager(_ manager: CharacterListCollectionManager,
                           editCharacterComment character: Character,
                           completion: @escaping ()->())
}

class CharacterListCollectionManager: NSObject {
    private let collectionView: UICollectionView
    private var characterListCancelable: Cancelable?
    private let commentSynchronizer = CharacterListCommentSynchronizer()
    private let pageCollector = ResponsePageCollector<Character>()
    private var isActive = false
    private let refreshControl = UIRefreshControl()

    var delegate: CharacterListCollectionManagerDelegate?

    init(withCollectionView collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlFired(_:)), for: .valueChanged)
    }

    @objc private func refreshControlFired(_ sender: Any) {
        characterListCancelable?.cancel()
        characterListCancelable = nil
        loadDataIfNeeded(isRefresh: true)
    }

    func activate() {
        guard isActive == false else {
            return
        }
        isActive = true
        loadDataIfNeeded()
    }

    func loadDataIfNeeded(isRefresh: Bool = false) {
        guard characterListCancelable == nil,
              isActive == true,
               pageCollector.isDataExhausted == false else {
            return
        }
        let offset = isRefresh ? 0 : pageCollector.count
        characterListCancelable = MarvelAPIAdapter.shared.loadCharacters(offset: offset) { [weak self] response in
            switch response {
            case .success(let result):
                guard let strongSelf = self else {
                    return
                }
                strongSelf.commentSynchronizer.fillWithComments(characters: result.results) {
                    if isRefresh {
                        strongSelf.refreshControl.endRefreshing()
                        strongSelf.pageCollector.reset()
                    }
                    strongSelf.updateCollectionView(withPage: result)
                }
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
        cell.commentDidTapBlock = { [weak self] in
            self?.editCharacter(atIndexPath: indexPath)
        }
        return cell
    }

    private func editCharacter(atIndexPath indexPath: IndexPath) {
        let character = pageCollector[indexPath.item]
        delegate?.collectionManager(self, editCharacterComment: character) { [weak self] in
            self?.commentSynchronizer.updateCommentForCharacter(character: character)
            self?.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension CharacterListCollectionManager: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let character = pageCollector[indexPath.item]
        var size = CGSize(width: collectionView.frame.size.width, height: 0)
        size.height = CharacterListCell.Metrics.height(withCharacter: character, maxWidth: size.width)
        return size
    }
}