//
//  UserController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    var user: [User] = []
    
    //MARK: CRUD FUNCS
    func createUserWith(name: String, age: Int, height: Double, weight: Double, gender: Bool)  {
        let _ = User(name: name, age: age, height: height, weight: weight, gender: gender)
        // CLOUD KIT SAVE NEW
    }
    func delete(user: User) {
        // CLOUD KIT DELETE RECORD
    }
    func update(user: User, name: String, age: Int, height: Double, weight: Double, gender: Bool) {
        user.name = name
        user.age = age
        user.height = height
        user.weight = weight
        user.gender = gender
        // CLOUDKIT MODIFY
    }
}
