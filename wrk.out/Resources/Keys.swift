//
//  Constants.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Keys {
    struct Workout {
        static let type = "Workout"
        static let name = "name"
        static let lifts = "lifts"
        static let duration = "duration"
        static let note = "note"
        static let ckRecordID = "ckRecordID"
        static let userReference = "userReference"
    }

    struct Lift {
        static let type = "Lift"
        static let name = "name"
        static let liftsets = "liftsets"
        static let ckRecordID = "ckRecordID"
        static let workoutReference = "workoutReference"
        static let routineReference = "routineReference"
    }

    struct Liftset {
        static let type = "LiftSet"
        static let weight = "weight"
        static let reps = "reps"
        static let ckRecordID = "ckRecordID"
        static let liftReference = "liftReference"
    }

    struct CloudKit {
        static let creatorUserRecordID = "creatorUserRecordID"
        static let lastModifiedUserRecordID = "creatorUserRecordID"
        static let creationDate = "creationDate"
        static let modificationDate = "modificationDate"
    }

    struct User {
        static let type = "User"
        static let name = "name"
        static let age = "age"
        static let weight = "weight"
        static let height = "height"
        static let gender = "gender"
        static let profileImage = "profileImage"
        static let appleUserReference = "appleUserReference"
    }

    struct Routine {
        static let routineName = "routineName"
        static let ckRecordID = "ckRecordID"
        static let type = "Routine"
        static let userReference = "userReference"
        static let routineLifts = "routineLifts"
    }
}
