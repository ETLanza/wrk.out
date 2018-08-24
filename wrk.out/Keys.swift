//
//  Constants.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Keys {
    struct WorkoutKeys {
        static let workoutTypeKey = "Workout"
        static let nameKey = "name"
        static let liftsKey = "lifts"
        static let durationKey = "duration"
        static let noteKey = "note"
        static let ckRecordIDKey = "ckRecordID"
    }
    
    struct LiftKeys {
        static let liftTypeKey = "Lift"
        static let nameKey = "name"
        static let setsKey = "sets"
        static let ckRecordIDKey = "ckRecordID"
        static let workoutReferenceKey = "workoutReference"
    }
    
    struct LiftsetKeys {
        static let liftsetTypeKey = "LiftSet"
        static let weightKey = "weight"
        static let repsKey = "reps"
        static let ckRecordIDKey = "ckRecordID"
        static let liftReference = "liftReference"
    }
    
    struct CloudKitKeys {
        static let creatorUserRecordIDKey = "creatorUserRecordID"
        static let lastModifiedUserRecordIDKey = "creatorUserRecordID"
        static let creationDateKey = "creationDate"
        static let modificationDateKey = "modificationDate"
    }
    
    struct PersonKeys {
        static let personTypeKey = "person"
        static let nameTypeKey = "name"
        static let ageTypeKey = "age"
        static let weightTypKey = "weight"
        static let heightTypeKey = "height"
        static let genderTypekey = "gender"
    }
}
