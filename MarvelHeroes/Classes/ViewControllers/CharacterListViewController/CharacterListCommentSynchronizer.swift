//
// Created by Артем on 08/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Dispatch

class CharacterListCommentSynchronizer {
    private let context = (UIApplication.shared.delegate! as! AppDelegate).persistentContainer.newBackgroundContext()

    func fillWithComments(characters: [Character], completion: @escaping ()->()) {
        context.perform { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Comment.fetchRequest()
            let identifiers = characters.map{$0.identifier!}
            let characterIdKey = "characterId"
            let textKey = "text"
            fetchRequest.predicate = NSPredicate(format: "characterId IN %@", identifiers)
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.propertiesToFetch = [characterIdKey, textKey]

            do {
                let results = try strongSelf.context.fetch(fetchRequest) as! [[String: Any]]
                var commentsByIdMap = [Int64: String]()
                for result in results {
                    commentsByIdMap[result[characterIdKey] as! Int64] = (result[textKey] as! String)
                }

                for character in characters {
                    character.comment = commentsByIdMap[character.identifier!]
                }
            } catch {
                print(error)
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func updateCommentForCharacter(character: Character) {
        let mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        mainContext.performAndWait {
            let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "characterId = %@", argumentArray: [character.identifier!])
            do {
                let results = try mainContext.fetch(fetchRequest)
                if let comment = results.first {
                    comment.text = character.comment
                } else {
                    let comment = NSEntityDescription.insertNewObject(forEntityName: Comment.entityName(), into: mainContext) as? Comment
                    comment?.characterId = character.identifier!
                    comment?.text = character.comment
                }
                try mainContext.save()
            } catch {
                print(error)
            }
        }
    }
}
