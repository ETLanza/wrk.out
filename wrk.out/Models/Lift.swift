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
    var liftsets: [LiftSet] = []
    var ckRecordID: CKRecordID
    var workoutReference: CKReference?
    var routineReference: CKReference?
    
    //MARK: - Initilizers
    init(name: String, workoutReference: CKReference?, routineReference: CKReference?) {
        self.name = name
        self.workoutReference = workoutReference
        self.routineReference = routineReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.LiftKeys.nameKey] as? String else { return nil }
        let workoutReference = ckRecord[Keys.LiftKeys.workoutReferenceKey] as? CKReference
        let routineReference = ckRecord[Keys.LiftKeys.routineReferenceKey] as? CKReference
        self.init(name: name, workoutReference: workoutReference, routineReference: routineReference)
        self.liftsets = []
        self.ckRecordID = ckRecord.recordID
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
        self.setValue(lift.routineReference, forKey: Keys.LiftKeys.routineReferenceKey)
    }
}
