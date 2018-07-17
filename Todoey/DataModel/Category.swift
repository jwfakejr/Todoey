//
//  Category.swift
//  Todoey
//
//  Created by John Fake on 7/16/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    // each category can have a number of items
    let items = List<Item>()
}
