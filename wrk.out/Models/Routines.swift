//
//  Routines.swift
//  wrk.out
//
//  Created by Sam on 8/30/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class RoutineList {
    let routines: [Routine]
    init(routines: [Routine]) {
        self.routines = routines
    }
}

class Routine {
    let routineName: String
    let routineReps: Int
    var ckRecordID: CKRecordID
    
    init(routineName: String, routineReps: Int) {
        self.routineName = routineName
        self.routineReps = routineReps
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let routineName = ckRecord[Keys.RoutineKeys.routineNameKey] as? String,
            let routineReps = ckRecord[Keys.RoutineKeys.routineRepsKey] as? Int else { return nil}
        self.init(routineName: routineName, routineReps: routineReps)
        self.ckRecordID = ckRecord.recordID
    }
}

extension CKRecord {
    convenience init(routine: Routine) {
        self.init(recordType: Keys.RoutineKeys.routineTypeKey, recordID: routine.ckRecordID)
        self.setValue(routine.routineName, forKey: Keys.RoutineKeys.routineNameKey)
        self.setValue(routine.routineReps, forKey: Keys.RoutineKeys.routineRepsKey)
    }
}
