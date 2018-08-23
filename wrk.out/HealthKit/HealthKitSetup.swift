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
    // call this function when a user connects an apple watch
    func authorizeHealthKit(completion: @escaping (Bool)->Void) {
        // if this device is capable of using healthkit...
        if HKHealthStore.isHealthDataAvailable() {
            // initialize the only healthstore needed
            let healthStore = HealthKitModels.healthStore
            
    
            // This data is solely for computing calories burned as accurately as possible
            let allTypesToRead = Set([
                
                HKObjectType.workoutType(),
                HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                HKObjectType.quantityType(forIdentifier: .heartRate)!
                
                ])
            
            // workout activity type will be HKWorkoutActivityType.functionalStrengthTraining :D
            // need to write and read the heartRate in order to calculate calories burned
            let allTypesToWrite = Set([
                
                HKObjectType.workoutType(),
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
                
                ])
            
            healthStore.requestAuthorization(toShare: allTypesToWrite, read: allTypesToRead) { (success, error) in
                if let error = error {
                    print("Access denied, restricted, or error due to \(error.localizedDescription)")
                    completion (false) ; return
                    
                }
                
                if success {
                   completion(true)
                    // could use work i believe,
                    // FIXME: - Or simply revisit at another time, could possibly pop back into the app, dont know yet. 
                    print("apple watch succcessfully paired and allowed permissions")
                }
            }
        }
    }
}
