//
// Created by Артем on 06/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class ResponsePage<T> {
    var count: Int = 0
    var limit: Int = 0
    var offset: Int = 0

    var results: [T] = []
}

class ResponsePageCollector<T> {
    private var objects: [T] = []
    private(set) var isDataExhausted: Bool = false

    var count: Int {
        objects.count
    }

    subscript(index: Int) -> T {
        objects[index]
    }

    func putPage(_ page: ResponsePage<T>) {
        objects.append(contentsOf: page.results)
        if page.count < page.limit {
            isDataExhausted = true
        }
    }

    func reset() {
        objects = []
        isDataExhausted = false
    }
}