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
    var user: User?
    
    func createRoutine(name: String, completion: @escaping (Bool) -> Void) {
        
        let routineReference = CKReference(recordID: user!.ckRecordID, action:.deleteSelf)
        let newRoutine = Routine(routineName: name, routineReference: routineReference)
        
        let routineAsRecord = CKRecord(routine: newRoutine)
        CloudKitManager.shared.saveRecord(routineAsRecord, database: CloudKitManager.shared.privateDatabase) { (record, error) in
            if let error = error {
                print("error saving routine as record to cloudkit \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record, let routineAsRecord = Routine(ckRecord: record) else {
                print("there was an error creating routine from CKRecord \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            self.routines.append(routineAsRecord)
            completion(true)
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
}
