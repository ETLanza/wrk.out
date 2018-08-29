//
//  user.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class User: Equatable {
    
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
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: Keys.UserKeys.userTypeKey,
                  recordID: user.ckRecordID)
        self.setValue(user.age,
                      forKey: Keys.UserKeys.ageTypeKey)
        self.setValue(user.name,
                      forKey: Keys.UserKeys.nameTypeKey)
        self.setValue(user.height,
                      forKey: Keys.UserKeys.heightTypeKey)
        self.setValue(user.weight,
                      forKey: Keys.UserKeys.weightTypKey)
        self.setValue(user.gender,
                      forKey: Keys.UserKeys.genderTypekey)
    }
}


