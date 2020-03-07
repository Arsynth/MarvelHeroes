//
// Created by Артем on 04/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func entityName() -> String {
        NSStringFromClass(self)
    }
}