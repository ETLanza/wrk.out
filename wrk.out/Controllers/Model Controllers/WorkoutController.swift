//
//  WorkoutController.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/22/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class WorkoutController {

    // MARK: - Shared Instance
    static let shared = WorkoutController()

    // MARK: - Properties
    var workouts: [Workout] = []

    // MARK: - CRUD Functions
    func createNewWorkoutWith(name: String, completion: @escaping (Workout?) -> Void) {
        guard let user = UserController.shared.loggedInUser else { return }
        let userReference = CKReference(recordID: user.ckRecordID, action: .deleteSelf)
        let newWorkout = Workout(name: name, userReference: userReference)
        let workoutRecord = CKRecord(workout: newWorkout)
        CloudKitManager.shared.saveRecord(workoutRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                NSLog("Error saving new workout: %@", error.localizedDescription)
                completion(nil)
                return
            }

            guard let record = record,
                let workoutFromRecord = Workout(ckRecord: record) else {
                    NSLog("Error creating workout from record: %@", name)
                    completion(nil)
                    return
            }
            completion(workoutFromRecord)
        }
    }

    func delete(workout: Workout, completion: @escaping (Bool) -> Void) {
        CloudKitManager.shared.deleteRecordWithID(workout.ckRecordID, database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                NSLog("Error deleting workout from CloudKit", error.localizedDescription)
                completion(false)
                return
            }

            if let _ = recordID {
                guard let index = self.workouts.index(of: workout) else {
                    NSLog("Error finding local index of lift: %@", workout.ckRecordID)
                    completion(false)
                    return
                }
                self.workouts.remove(at: index)
                completion(true)
                return
            }
            completion(false)
        }
    }

    func modify(workout: Workout, withName name: String, note: String, duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        workout.name = name
        workout.note = note
        workout.duration = duration

        let workoutRecord = CKRecord(workout: workout)
        CloudKitManager.shared.modifyRecords([workoutRecord], database: CloudKitManager.shared.privateDatabase, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                NSLog("Error modifying workout in CloudKit", error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }

    // MARK: - CloudKitMethods
    func fetchAllWorkoutsFor(user: User, completion: @escaping (Bool) -> Void) {

        let predicate = NSPredicate(format: "\(Keys.Workout.userReference) == %@", user.ckRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)

        CloudKitManager.shared.fetchRecordsOfType(Keys.Workout.type, predicate: predicate, database: CloudKitManager.shared.privateDatabase, sortDescriptors: [sortDescriptor]) { (records, error) in
            if let error = error {
                NSLog("Error fetching workouts from CloudKit", error.localizedDescription)
                completion(false)
                return
            }

            guard let records = records else {
                NSLog("Error finding all workouts from CloudKit")
                completion(false)
                return
            }

            let workouts = records.compactMap { Workout(ckRecord: $0) }
            self.workouts = workouts
            completion(true)
        }
    }
}
