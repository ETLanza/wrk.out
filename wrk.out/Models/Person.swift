//
//  Person.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class Person: Equatable {
    
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var gender: Bool
    var ckRecordID: CKRecordID
    
    init(name: String, age: Int, height: Double, weight: Double, gender: Bool) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    //MARK: - Equatable
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(person: Person) {
        self.init(recordType: Keys.PersonKeys.personTypeKey,
                  recordID: person.ckRecordID)
        self.setValue(person.age,
                      forKey: Keys.PersonKeys.ageTypeKey)
        self.setValue(person.name,
                      forKey: Keys.PersonKeys.nameTypeKey)
        self.setValue(person.height,
                      forKey: Keys.PersonKeys.heightTypeKey)
        self.setValue(person.weight,
                      forKey: Keys.PersonKeys.weightTypKey)
        self.setValue(person.gender,
                      forKey: Keys.PersonKeys.genderTypekey)
    }
}


