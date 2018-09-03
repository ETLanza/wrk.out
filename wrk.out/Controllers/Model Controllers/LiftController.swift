//
//  LiftController.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/22/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class LiftController {
    
    static let shared = LiftController()
    
    //MARK: - CRUD Functions
    func addLiftTo(workout: Workout, name: String, completion: @escaping ((Bool) -> Void)) {
        let workoutReference = CKReference(recordID: workout.ckRecordID, action: .deleteSelf)
        let newLift = Lift(name: name, workoutReference: workoutReference, routineReference: nil)
        let liftRecord = CKRecord(lift: newLift)
        
        CloudKitManager.shared.saveRecord(liftRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                NSLog("Error saving lift to CloudKit", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let record = record,
                let liftFromRecord = Lift(ckRecord: record) else {
                    NSLog("Error creating lift from CKRecord: %@", name)
                    completion(false)
                    return
            }
            workout.lifts.append(liftFromRecord)
            LiftSetController.shared.addLiftset(toLift: liftFromRecord, weight: 0, reps: 0, completion: { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    func delete(lift: Lift, fromWorkout workout: Workout, completion: @escaping (Bool)-> Void) {
        CloudKitManager.shared.deleteRecordWithID(lift.ckRecordID, database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                NSLog("Error deleting lift from CloudKit", error.localizedDescription)
                completion(false)
                return
            }
            
            if let _ = recordID {
                guard let index = workout.lifts.index(of: lift) else {
                    NSLog("Error finding local index of lift: %@", lift.ckRecordID)
                    completion(false)
                    return
                }
                workout.lifts.remove(at: index)
                completion(true)
            }
        }
    }
    
    func modify(lift: Lift, withName name: String, completion: @escaping (Bool)->Void) {
        lift.name = name
        
        let recordToModify = CKRecord(lift: lift)
        
        CloudKitManager.shared.modifyRecords([recordToModify], database: CloudKitManager.shared.privateDatabase, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                NSLog("Error modifying lift in CloudKit", error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //MARK: - CloudKit Methods
    func fetchAllLiftsFor(workout: Workout, completion: @escaping (Bool)->Void) {
        let predicate = NSPredicate(format: "\(Keys.LiftKeys.workoutReferenceKey) == %@", workout.ckRecordID)
        
        CloudKitManager.shared.fetchRecordsOfType(Keys.LiftKeys.liftTypeKey, predicate: predicate, database: CloudKitManager.shared.privateDatabase, sortDescriptors: nil) { (records, error) in
            if let error = error {
                NSLog("Error fething Lifts for &@ from CloudKit: %@", [workout.name, error.localizedDescription])
                completion(false)
                return
            }
            
            guard let records = records else {
                NSLog("Error finding records for Workout: %@", workout.name)
                completion(false)
                return
            }
            
            let lifts = records.compactMap { Lift(ckRecord: $0) }
            workout.lifts = lifts
            completion(true)
            
        }
    }
}
