//
//  Lift.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class Lift: Equatable {
    
    //MARK: - Properties
    var name: String
    var sets: [Sets] = []
    var ckRecordID: CKRecordID
    var workoutReference: CKReference
    
    //MARK: - Initilizers
    init(name: String, workoutReference: CKReference) {
        self.name = name
        self.workoutReference = workoutReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.LiftKeys.nameKey] as? String,
            let workoutReference = ckRecord[Keys.LiftKeys.workoutReferenceKey] as? CKReference else { return nil }
        self.init(name: name, workoutReference: workoutReference)
        self.sets = []
    }
    
    //MARK: - Equatable
    static func == (lhs: Lift, rhs: Lift) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

//MARK: - CKRecord Init for Lift
extension CKRecord {
    convenience init(lift: Lift) {
        self.init(recordType: Keys.LiftKeys.liftTypeKey, recordID: lift.ckRecordID)
        self.setValue(lift.name, forKey: Keys.LiftKeys.nameKey)
        self.setValue(lift.workoutReference, forKey: Keys.LiftKeys.workoutReferenceKey)
    }
}
