//
//  Pool.swift
//  principools
//
//  Created by DJ Satoda on 6/16/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import Foundation
import RealmSwift

class Pool : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var averageScore : Float = 0
    @objc dynamic var dateCreated : Date?
    let principles = List<Principle>()
    
}
