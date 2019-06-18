//
//  Category.swift
//  principools
//
//  Created by DJ Satoda on 6/16/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import Foundation
import RealmSwift

class Principle : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var dateCreated : Date?
    
    // defines one to many relationship
    let dots = List<Dot>()
    
    // defines many to one relationship
    var parentPool = LinkingObjects(fromType: Pool.self, property: "principles")
    
    @objc dynamic var score : Float = 0
}
