//
//  user.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import CloudKit

class User: Equatable {
    
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var gender: String
//    var profileImage: UIImage
    var ckRecordID: CKRecordID
    let appleUserReference: CKReference
    
    init(name: String, age: Int, height: Double, weight: Double, gender: String, appleUserReference: CKReference) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
//        self.profileImage = profileImage
        self.appleUserReference = appleUserReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.UserKeys.nameTypeKey] as? String,
            let age = ckRecord[Keys.UserKeys.ageTypeKey] as? Int,
            let height = ckRecord[Keys.UserKeys.heightTypeKey] as? Double,
            let weight = ckRecord[Keys.UserKeys.weightTypKey] as? Double,
            let gender = ckRecord[Keys.UserKeys.genderTypekey] as? String,
            // profile image TODO
            let appleUserReference = ckRecord[Keys.UserKeys.appleUserReferenceKey] as? CKReference else { return nil }
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
        self.appleUserReference = appleUserReference
        self.ckRecordID = ckRecord.recordID
    }
    
    //MARK: - Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: Keys.UserKeys.userTypeKey, recordID: user.ckRecordID)
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
        self.setValue(user.appleUserReference, forKey: Keys.UserKeys.appleUserReferenceKey)
    }
}


