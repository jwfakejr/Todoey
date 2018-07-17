//
//  Item.swift
//  Todoey
//
//  Created by John Fake on 7/16/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    // optional Date created property ....note the ?
    @objc dynamic var dateCreated: Date? 
    var parentCategory = LinkingObjects(fromType: Category.self, property:"items")
}
