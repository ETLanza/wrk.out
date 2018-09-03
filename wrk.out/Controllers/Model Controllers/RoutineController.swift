//
//  RoutineController.swift
//  wrk.out
//
//  Created by Sam on 8/30/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class RoutineController {
    
    static let shared = RoutineController()
    
    var routines: [Routine] = []
//    var routine: Routine?
    var user: User?
    
    func createRoutine(name: String, completion: @escaping (Routine?) -> Void) {
        
        let routineReference = CKReference(recordID: user!.ckRecordID, action:.deleteSelf)
        let newRoutine = Routine(routineName: name, routineReference: routineReference)
        
        let routineAsRecord = CKRecord(routine: newRoutine)
        CloudKitManager.shared.saveRecord(routineAsRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                print("error saving routine as record to cloudkit \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record, let routineAsRecord = Routine(ckRecord: record) else {
                print("there was an error creating routine from CKRecord \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            self.routines.append(routineAsRecord)
            completion(routineAsRecord)
        }
    }
    
    func remove(routine: Routine, completion: @escaping (Bool)->Void) {
        CloudKitManager.shared.deleteRecordWithID(routine.ckRecordID, database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                print("there was an error deleting the routine from cloudkit, \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let _ = recordID {
                guard let index = self.routines.index(of: routine) else {
                    print("There was an error finding local index of routine")
                    completion(false)
                    return
                }
                self.routines.remove(at: index)
                completion(true)
            }
        }
    }
    
    func modifyRoutine(routine: Routine, name: String, completion: @escaping (Bool)-> Void) {
        routine.routineName = name
        let routineRecord = CKRecord(routine: routine)
        CloudKitManager.shared.modifyRecords([routineRecord], database: CloudKitManager.shared.privateDatabase, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("there was an error modifying the routine name \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    func createLift(name: String, routine: Routine, completion: @escaping (Bool)->Void) {
        let routineReference = CKReference(recordID: routine.ckRecordID, action: .deleteSelf)
        let newLift = Lift(name: name, workoutReference: routineReference)
        let ckRecord = CKRecord(lift: newLift)
        CloudKitManager.shared.saveRecord(ckRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                print("there was an error saving a lift to the routine in the CK database \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let liftRecord = Lift(ckRecord: record)
                else {
                    print("there was an error returning a liftRecord (routine) from the CK Database \(error!.localizedDescription)")
                    completion(false)
                    return
            }
            routine.routineLifts.append(liftRecord)
            completion(true)
        }
    }
    
    func deleteLift(lift: Lift, routine: Routine, completion: @escaping (Bool)->Void) {
        CloudKitManager.shared.deleteRecordWithID(lift.ckRecordID, database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                print("there was an error deleting the lift with \(lift.ckRecordID) \(error.localizedDescription)")
                completion(false)
                return
            }
            if let _ = recordID {
                guard let index = routine.routineLifts.index(of: lift) else {
                    completion(false)
                    return
                }
                routine.routineLifts.remove(at: index)
                completion(true)
            }
        }
    }
    func modifyLiftInRoutine(lift: Lift, routine: Routine, name: String, completion: @escaping (Bool)->Void) {
        lift.name = name
        let liftRecord = CKRecord(lift: lift)
        CloudKitManager.shared.saveRecord(liftRecord, database: CloudKitManager.shared.privateDatabase) { (_, error) in
            if let error = error {
                print("there was an error modifying the lift name \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func addLiftSetToRoutine(lift: Lift, routine: Routine, weight: Double, reps: Int, completion: @escaping (Bool)->Void) {
        let liftReference = CKReference(recordID: lift.ckRecordID, action: .deleteSelf)
        let newLiftSet = LiftSet(weight: weight, reps: reps, liftReference: liftReference)
        let ckRecord = CKRecord(liftset: newLiftSet)
        CloudKitManager.shared.saveRecord(ckRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                print("there was an error saving lifts to the routines in CloudKit \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let record = record, let liftSetRecord = LiftSet(ckRecord: record) else {
                print("there was an error saving the liftSet as a record \(error!.localizedDescription)")
                completion(false)
                return
            }
            lift.liftsets.append(liftSetRecord)
            completion(true)
        }
    }
    func deleteLiftSetFrom(routine: Routine, lift: Lift, liftset: LiftSet, completion: @escaping (Bool)->Void) {
        CloudKitManager.shared.deleteRecordWithID(liftset.ckRecordID , database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                print("there was an error deleting the liftSet within the routine from cloudkit \(error.localizedDescription)")
                completion(false)
                return
            }
            if let _ = recordID {
                guard let index = lift.liftsets.index(of: liftset) else {
                    print("There was an error index of the liftSet \(error!.localizedDescription)")
                    completion(false)
                    return
                }
                lift.liftsets.remove(at: index)
                completion(true)
            }
        }
    }
    func modifyLiftSetIn(routine: Routine, lift: Lift, liftSet: LiftSet, weight: Double, reps: Int, completion: @escaping (Bool)->Void) {
        liftSet.reps = reps
        liftSet.weight = weight
        let LiftSetRecord = CKRecord(liftset: liftSet)
        CloudKitManager.shared.modifyRecords([LiftSetRecord], database: CloudKitManager.shared.privateDatabase, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("there was an error modifying the liftSet in a routine \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
