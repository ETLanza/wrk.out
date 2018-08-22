//
//  HealthKitController.swift
//  wrk.out
//
//  Created by Sam on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import HealthKit

struct HealthKitController {
    var startWorkout: Date
    var endWorkout: Date
    
    init(startWorkout: Date, endWorkout: Date) {
        self.startWorkout = startWorkout
        self.endWorkout = endWorkout
    }
    
}
