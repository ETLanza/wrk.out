//
//  PersonController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class PersonController {
    
    var person: [Person] = []
    
    //MARK: CRUD FUNCS
    func createPersonWith(name: String, age: Int, height: Double, weight: Double, gender: Bool)  {
        let _ = Person(name: name, age: age, height: height, weight: weight, gender: gender)
        // CLOUD KIT SAVE NEW
    }
    func delete(person: Person) {
        // CLOUD KIT DELETE RECORD
    }
    func update(person: Person, name: String, age: Int, height: Double, weight: Double, gender: Bool) {
        person.name = name
        person.age = age
        person.height = height
        person.weight = weight
        person.gender = gender
        // CLOUDKIT MODIFY
    }
}
