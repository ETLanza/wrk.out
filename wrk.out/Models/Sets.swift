//
//  Set.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class Sets: Equatable {
    
    var weight: Double
    var reps: Int
    var ckRecordID: CKRecordID
    var liftReference: CKReference
    
    
    init(weight: Double, reps: Int, liftReference: CKReference){
        self.weight = weight
        self.reps = reps
        self.liftReference = liftReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let weight = ckRecord[Constants.SetConstants.weightKey] as? Double,
        let reps = ckRecord[Constants.SetConstants.repsKey] as? Int,
            let liftReference = ckRecord[Constants.SetConstants.liftReference] as? CKReference else { return nil }
        self.init(weight: weight, reps: reps, liftReference: liftReference)
        self.ckRecordID = ckRecord.recordID
    }
    
    //MARK: - Equatable
    static func == (lhs: Sets, rhs: Sets) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

//MARK: - CKRecord Init for Set
extension CKRecord {
    convenience init(set: Sets) {
        self.init(recordType: Constants.SetConstants.setTypeKey, recordID: set.ckRecordID)
        self.setValue(set.weight, forKey: Constants.SetConstants.weightKey)
        self.setValue(set.reps, forKey: Constants.SetConstants.weightKey)
        self.setValue(set.liftReference, forKey: Constants.SetConstants.liftReference)
    }
}
