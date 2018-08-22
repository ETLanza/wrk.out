//
//  LiftSetController.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class LiftSetController {
    
    //MARK: - CRUD Functions
    func addLiftset(toLift lift: Lift, weight: Double, reps: Int, liftReference: CKReference) {
        let newLiftset = LiftSet(weight: weight, reps: reps, liftReference: liftReference)
        let setAsRecord = CKRecord(liftset: newLiftset)
        CloudKitManager.shared.saveRecord(setAsRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                NSLog("Error saving LiftSet to CloudKit: %@", error.localizedDescription)
            }
            
            guard let record = record,
                let liftsetFromRecord = LiftSet(ckRecord: record) else { return }
            
            lift.sets.append(liftsetFromRecord)
        }
    }
    
    func delete(liftset: LiftSet, fromLift lift: Lift) {
        CloudKitManager.shared.deleteRecordWithID(liftset.ckRecordID, database: CloudKitManager.shared.privateDatabase) { (recordID, error) in
            if let error = error {
                NSLog("Error deleting LiftSet from CloudKit: %@", error.localizedDescription)
            }
            if let _ = recordID {
                guard let index = lift.sets.index(of: liftset) else { return }
                lift.sets.remove(at: index)
            }
        }
    }
    
    func update(liftset: LiftSet, withWeight weight: Double, andReps reps: Int) {
        liftset.weight = weight
        liftset.reps = reps
        
        let recordToModify = CKRecord(liftset: liftset)
        
        CloudKitManager.shared.modifyRecords([recordToModify], database: CloudKitManager.shared.privateDatabase, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                NSLog("Error modifing LiftSet in CloudKit: %@", error.localizedDescription)
            }
        }
    }
    
    //MARK: - CloudKit Methods
    func fetchAllLiftsetsFor(lift: Lift, completion: @escaping (Bool)-> Void) {
        
        let predicate = NSPredicate(format: "\(Keys.LiftsetKeys.liftReference) == %@", lift.ckRecordID)
        
        CloudKitManager.shared.fetchRecordsOfType(Keys.LiftsetKeys.liftsetTypeKey, predicate: predicate, database: CloudKitManager.shared.privateDatabase, sortDescriptors: nil) { (records, error) in
            if let error = error {
                NSLog("Error Fetching LiftSets from CloudKit: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            
            let sets = records.compactMap { LiftSet(ckRecord: $0) }
            
            lift.sets = sets
            completion(true)
        }
    }
}



















