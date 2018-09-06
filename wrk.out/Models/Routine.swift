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
    let userReference: CKReference?

    var routineLifts: [Lift] = []

    init(routineName: String, userReference: CKReference) {
        self.routineName = routineName
        self.userReference = userReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let routineName = ckRecord[Keys.Routine.routineName] as? String,
            let userReference = ckRecord[Keys.Routine.userReference] as? CKReference
            else { return nil }
        
        self.init(routineName: routineName, userReference: userReference)
        self.ckRecordID = ckRecord.recordID
    }
}

extension CKRecord {
    convenience init(routine: Routine) {
        self.init(recordType: Keys.Routine.type, recordID: routine.ckRecordID)
        self.setValue(routine.routineName, forKey: Keys.Routine.routineName)
        self.setValue(routine.userReference, forKey: Keys.Routine.userReference)
    }
}

extension Routine: Equatable {
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
