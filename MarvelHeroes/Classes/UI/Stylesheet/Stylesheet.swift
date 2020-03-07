//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

protocol StyleSheet {
    associatedtype ObjectType
    func apply(on object: ObjectType)
}