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
    func averageHeartRate() {
        let heartRate = HealthKitModels.heartRate
        let startTime = startWorkout
        let endTime = endWorkout
        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startTime, end: endTime, options: HKQueryOptions.strictEndDate)
        
        let squery = HKStatisticsQuery(quantityType: heartRate!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let quantity: HKQuantity? = result?.averageQuantity()
                let beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                print("got: \(String(format: "%.f", beats!))")
            })
        })
        HealthKitModels.healthStore.execute(squery)
    }
}
