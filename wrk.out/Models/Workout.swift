//
//  Workout.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class Workout: Equatable {
    var name: String
    var lifts: [Lift] = []
    var duration: TimeInterval
    var startTime = Date()
    var note: String
    var ckRecordID: CKRecordID
    var userReference: CKReference
    
    init(name: String, userReference: CKReference) {
        self.name = name
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
        self.duration = 0
        self.note = ""
        self.userReference = userReference
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.Workout.name] as? String ,
        let duration = ckRecord[Keys.Workout.duration] as? TimeInterval,
        let note = ckRecord[Keys.Workout.note] as? String,
        let userReference = ckRecord[Keys.Workout.userReference] as? CKReference
        else { return nil }
        self.init(name: name, userReference: userReference)
        self.ckRecordID = ckRecord.recordID
        self.duration = duration
        self.note = note
    }
    
    //MARK: - Equatable
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(workout: Workout) {
        self.init(recordType: Keys.Workout.type, recordID: workout.ckRecordID)
        self.setValue(workout.name, forKey: Keys.Workout.name)
        self.setValue(workout.duration, forKey: Keys.Workout.duration)
        self.setValue(workout.note, forKey: Keys.Workout.note)
        self.setValue(workout.userReference, forKey: Keys.Workout.userReference)
    }
}
