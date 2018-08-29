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
    var duration: TimeInterval?
    var startTime = Date()
    var note: String?
    var ckRecordID: CKRecordID
    
    init(name: String) {
        self.name = name
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
        self.duration = 0
        self.note = ""
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.WorkoutKeys.nameKey] as? String
            //            let duration = ckRecord[Keys.WorkoutKeys.durationKey] as? TimeInterval
            else { return nil }
        let note = ckRecord[Keys.WorkoutKeys.noteKey] as? String
        self.init(name: name)
        self.ckRecordID = ckRecord.recordID
        self.duration = 0
        self.note = note
    }
    
    //MARK: - Equatable
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(workout: Workout) {
        self.init(recordType: Keys.WorkoutKeys.workoutTypeKey, recordID: workout.ckRecordID)
        self.setValue(workout.name, forKey: Keys.WorkoutKeys.nameKey)
        self.setValue(workout.duration, forKey: Keys.WorkoutKeys.durationKey)
        self.setValue(workout.note, forKey: Keys.WorkoutKeys.noteKey)
    }
}
