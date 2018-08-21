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
    
    var sets: [Sets] = []
    
    //MARK: - CRUD Functions
    func createSetWith(weight: Double, reps: Int, liftReference: CKReference) {
        let _ = Sets(weight: weight, reps: reps, liftReference: liftReference)
        // CLOUD KIT SAVE NEW
    }
    
    func delete(set: Sets) {
        //CLOUDKIT DELETE RECORD
    }
    
    func update(set: Sets, withWeight weight: Double, andReps reps: Int) {
        set.weight = weight
        set.reps = reps
        // CLOUDKIT MODIFY
    }
}
