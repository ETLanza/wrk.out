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
    static let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
    static let gender = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
    static let height = HKObjectType.quantityType(forIdentifier: .height)
    static let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)
    
}
