//
//  Set.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class LiftSet: Equatable {

    var weight: Double
    var reps: Int
    var ckRecordID: CKRecordID
    var liftReference: CKReference

    init(weight: Double, reps: Int, liftReference: CKReference) {
        self.weight = weight
        self.reps = reps
        self.liftReference = liftReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }

    convenience init?(ckRecord: CKRecord) {
        guard let weight = ckRecord[Keys.Liftset.weight] as? Double,
            let reps = ckRecord[Keys.Liftset.reps] as? Int,
            let liftReference = ckRecord[Keys.Liftset.liftReference] as? CKReference else { return nil }
        self.init(weight: weight, reps: reps, liftReference: liftReference)
        self.ckRecordID = ckRecord.recordID
    }

    // MARK: - Equatable
    static func == (lhs: LiftSet, rhs: LiftSet) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

// MARK: - CKRecord Init for Set
extension CKRecord {
    convenience init(liftset: LiftSet) {
        self.init(recordType: Keys.Liftset.type, recordID: liftset.ckRecordID)
        self.setValue(liftset.weight, forKey: Keys.Liftset.weight)
        self.setValue(liftset.reps, forKey: Keys.Liftset.reps)
        self.setValue(liftset.liftReference, forKey: Keys.Liftset.liftReference)
    }
}
