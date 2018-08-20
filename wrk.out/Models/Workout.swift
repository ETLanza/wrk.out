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
    var lifts: [Lift] = []
    var duration: TimeInterval
    var note: String?
    var ckRecordID: CKRecordID
    
    init(duration: TimeInterval) {
        self.duration = duration
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let duration = ckRecord[Constants.WorkoutConstants.durationKey] as? TimeInterval else { return nil }
         let note = ckRecord[Constants.WorkoutConstants.noteKey] as? String
        self.init(duration: duration)
        self.ckRecordID = ckRecord.recordID
        self.note = note
    }
    
    //MARK: - Equatable
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(workout: Workout) {
        self.init(recordType: Constants.WorkoutConstants.workoutTypeKey, recordID: workout.ckRecordID)
        self.setValue(workout.duration, forKey: Constants.WorkoutConstants.durationKey)
        self.setValue(workout.note, forKey: Constants.WorkoutConstants.noteKey)
    }
}
