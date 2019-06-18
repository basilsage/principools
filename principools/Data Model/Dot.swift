//
//  Item.swift
//  principools
//
//  Created by DJ Satoda on 6/16/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import Foundation
import RealmSwift

class Dot : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var score : Float = 0
    @objc dynamic var dateCreated : Date?
    
    // points to parent principle
    var parentPrinciple = LinkingObjects(fromType: Principle.self, property: "dots")
}
