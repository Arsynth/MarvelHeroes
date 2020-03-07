//
// Created by Артем on 04/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class DebugKeyStoreManager {
    static let shared = DebugKeyStoreManager()
    private var keysCache: DebugKeysCache?

    private init() {

    }

    var publicKey: String? {
        get {
            loadCacheIfNeeded()
            return keysCache?.publicKey
        } set {
            loadCacheIfNeeded()
            keysCache?.publicKey = newValue
        }
    }

    var privateKey: String? {
        get {
            loadCacheIfNeeded()
            return keysCache?.privateKey
        } set {
            loadCacheIfNeeded()
            keysCache?.privateKey = newValue
        }
    }

    private func loadCacheIfNeeded() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<DebugKeysCache> = DebugKeysCache.fetchRequest()

                let result = try context.fetch(fetchRequest)
                guard result.count <= 1 else {
                    fatalError("There are more than one cache. How dare you??!")
                }
                keysCache = result.first
                if keysCache == nil {
                    createCache(inContext: context)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Error while fetching \(nserror), \(nserror.userInfo)")
            }

        }
    }

    private func createCache(inContext context: NSManagedObjectContext) {
        keysCache = NSEntityDescription.insertNewObject(forEntityName: DebugKeysCache.entityName(), into: context) as? DebugKeysCache
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.saveContext()
    }
}
