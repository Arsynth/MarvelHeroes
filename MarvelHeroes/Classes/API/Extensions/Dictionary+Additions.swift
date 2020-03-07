//
// Created by Артем on 07/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

extension Dictionary {
    func merged(withDict dict: [Key: Value]) -> [Key: Value] {
        var newDict = self
        newDict.merge(withDict: dict)
        return newDict
    }

    mutating func merge(withDict dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}