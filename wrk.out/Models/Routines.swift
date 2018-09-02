//
//  Routines.swift
//  wrk.out
//
//  Created by Sam on 8/30/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class Routine {
    var routineName: String
    var ckRecordID: CKRecordID
    let routineReference: CKReference?
    var routineLifts: [Lift] = []
    init(routineName: String, routineReference: CKReference) {
    self.routineName = routineName
    self.routineReference = routineReference
    self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let routineName = ckRecord[Keys.RoutineKeys.routineNameKey] as? String,
            let routineReference = ckRecord[Keys.RoutineKeys.routineReferenceKey] as? CKReference
            else { return nil }
        
        self.init(routineName: routineName, routineReference: routineReference)
        self.ckRecordID = ckRecord.recordID
    }
}

extension CKRecord {
    convenience init(routine: Routine) {
        self.init(recordType: Keys.RoutineKeys.routineTypeKey, recordID: routine.ckRecordID)
        self.setValue(routine.routineName, forKey: Keys.RoutineKeys.routineNameKey)
    }
}

extension Routine: Equatable {
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
