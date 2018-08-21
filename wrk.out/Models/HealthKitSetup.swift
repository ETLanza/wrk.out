//
//  HealthKitSetup.swift
//  wrk.out
//
//  Created by Sam on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSetup {
    func authorizeHealthKit(completion: @escaping (Bool)->Void) {
        // if this device is capable of using healthkit...
        if HKHealthStore.isHealthDataAvailable() {
            // initialize the only healthstore needed
            let healthStore = HKHealthStore()
            
            // changes: set up healthKitModels, healthKitSetup (both do as they sound), requested access to health kit, changed info plist with request (description is 100% needed)
            
            let allTypes = Set([
                HKObjectType.workoutType(),
//                HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
//                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                HKObjectType.quantityType(forIdentifier: .height)!,
                HKObjectType.quantityType(forIdentifier: .bodyMass)!
                ])
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if let error = error {
                    print("Access denied, restricted, or error due to \(error.localizedDescription)")
                    completion (false) ; return
                    // possibly display an alert telling them that its essential for the app, or allow them to input the data themselves in the profile page, dont know yet
                    // call whenever it logically makes sense to request health kit permission
                }
                if success {
                    // segue into the app
                }
            }
        }
    }
}
