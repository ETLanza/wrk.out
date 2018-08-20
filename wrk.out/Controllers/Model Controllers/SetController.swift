//
//  SetController.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CloudKit

class SetController {
    
    var sets: [Set] = []
    
    //MARK: - CRUD Functions
    func createSetWith(weight: Double, reps: Int, liftReference: CKReference) {
        let _ = Set(weight: weight, reps: reps, liftReference: liftReference)
        // CLOUD KIT SAVE NEW
    }
    
    func delete(set: Set) {
        //CLOUDKIT DELETE RECORD
    }
    
    func update(set: Set, withWeight weight: Double, andReps reps: Int) {
        set.weight = weight
        set.reps = reps
        // CLOUDKIT MODIFY
    }
}
