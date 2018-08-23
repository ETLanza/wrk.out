//
//  Constants.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Constants {
    struct WorkoutConstants {
        static let workoutTypeKey = "Workout"
        static let liftsKey = "lifts"
        static let durationKey = "duration"
        static let noteKey = "note"
        static let ckRecordIDKey = "ckRecordID"
    }
    
    struct LiftConstants {
        static let liftTypeKey = "Lift"
        static let nameKey = "name"
        static let setsKey = "sets"
        static let ckRecordIDKey = "ckRecordID"
        static let workoutReferenceKey = "workoutReference"
    }
    
    struct SetConstants {
        static let setTypeKey = "Set"
        static let weightKey = "weight"
        static let repsKey = "reps"
        static let ckRecordIDKey = "ckRecordID"
        static let liftReference = "liftReference"
    }
    
    struct CloudKitConstants {
        static let creatorUserRecordIDKey = "creatorUserRecordID"
        static let lastModifiedUserRecordIDKey = "creatorUserRecordID"
        static let creationDateKey = "creationDate"
        static let modificationDateKey = "modificationDate"
    }
    
    struct PersonConstants {
        static let personTypeKey = "person"
        static let nameTypeKey = "name"
        static let ageTypeKey = "age"
        static let weightTypKey = "weight"
        static let heightTypeKey = "height"
        static let genderTypekey = "gender"
    }
}
