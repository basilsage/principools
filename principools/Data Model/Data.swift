//
//  Data.swift
//  principools
//
//  Created by DJ Satoda on 6/15/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    
    // Dynamic = declaration modifier, allows properties to be monitred for change while object is running. Thus, if user changes value during their use period, then Realm dynamically updates changes in database
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
