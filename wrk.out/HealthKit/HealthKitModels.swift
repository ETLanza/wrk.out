//
//  HealthKitModels.swift
//  wrk.out
//
//  Created by Sam on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitModels {
    // not sure if necessary, outdated tutorial from raywonderlich showed it this way for mvc
    static let age = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
    static let gender = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
    static let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
    static let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
    static let energyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
    static let healthStore = HKHealthStore()

}
