//
//  UserController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //shared instance
    static let shared = UserController()
    
    //properties
    var loggedInUser: User?
    
    //Public Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: CRUD FUNCS
    func createUserWith(name: String, age: Int, height: Double, weight: Double, gender: String, profileImageAsData: Data?, completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error fetching user RecordID: \(error)")
                completion(false); return
            }
            
            guard let recordID = recordID else { completion(false); return }
            
            let reference = CKReference(recordID: recordID, action: .deleteSelf)
            let newUser = User(name: name, age: age, height: height, weight: weight, gender: gender, profileImageAsData: profileImageAsData, appleUserReference: reference)
            self.saveUserToCloudKit(user: newUser)
            self.loggedInUser = newUser
            completion(true)
        }
    }
    
    //MARK: - CloudKit Functions
    func saveUserToCloudKit(user: User) {
        let ckRecord = CKRecord(user: user)
        privateDB.save(ckRecord) { (_, error) in
            if let error = error {
                print("Error saving user to CloudKit: \(error)")
            }
        }
    }
    
    func update(user: User, name: String, age: Int, height: Double, weight: Double, gender: String, profileImageAsData: Data?, completion: @escaping (Bool) -> Void) {
        
        user.name = name
        user.age = age
        user.height = height
        user.weight = weight
        user.gender = gender
        user.profileImageAsData = profileImageAsData
        //user. image
        let record = CKRecord(user: user)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.completionBlock = { completion(true) }
        privateDB.add(operation)
    }
    
    func fetchUserFromCloudKit(completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error fetching user record ID: \(error)")
                completion(false); return
            }
            
            guard let recordID = recordID else { completion(false); return }
            
            let predicate = NSPredicate(format: "appleUserReference == %@", recordID)
            let query = CKQuery(recordType: Keys.UserKeys.userTypeKey, predicate: predicate)
            
            self.privateDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("Error performing CloudKit query for users: \(error)")
                    completion(false); return
                }
                
                guard let records = records,
                    let record = records.first else { completion(false); return }
                //                    let recordsToDelete = records.compactMap{ $0.recordID }
                //                    let delete = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordsToDelete )
                //                    self.privateDB.add(delete)
                
                let user = User(ckRecord: record)
                
                self.loggedInUser = user
                completion(true)
            })
        }
    }
}
