//
//  Data.swift
//  Todoey
//
//  Created by John Fake on 7/16/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // Runtime monitors and updates the backing database when modified
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
