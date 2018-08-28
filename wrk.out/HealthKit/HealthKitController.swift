//
//  HealthKitController.swift
//  wrk.out
//
//  Created by Sam on 8/20/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import HealthKit
import NotificationCenter

struct HealthKitController {
    
    var startWorkout: Date
    var endWorkout: Date


    init(startWorkout: Date, endWorkout: Date) {
        self.startWorkout = startWorkout
        self.endWorkout = endWorkout
    
    }
    let healthStore = HKHealthStore()
    
    func averageHeartRate() {
        let heartRate = HealthKitModels.heartRate
        let startTime = startWorkout
        let endTime = endWorkout
        let predicate: NSPredicate? = HKQuery.predicateForSamples(withStart: startTime, end: endTime, options: HKQueryOptions.strictEndDate)
        // strict end disallows for start time to be later than the end time and vice versa
        
        let squery = HKStatisticsQuery(quantityType: heartRate!, quantitySamplePredicate: predicate, options: .discreteAverage, completionHandler: {(query: HKStatisticsQuery,result: HKStatistics?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let quantity: HKQuantity? = result?.averageQuantity()
                let beats: Double? = quantity?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                print("got: \(String(format: "%.f", beats!))")
            })
        })
        HealthKitModels.healthStore.execute(squery)
    }
    
    func gettingAge()-> Int? {
        
        let birthDate = try? HealthKitModels.healthStore.dateOfBirthComponents()
        
        let birthDateAsDate = NSCalendar.current.date(from: birthDate!)
        let currentDate = Date()
        let calendarTest = NSCalendar(calendarIdentifier: .gregorian)
        
        let differenceBetween = calendarTest?.compare(currentDate, to: birthDateAsDate!, toUnitGranularity: .year)
        
        let age = differenceBetween
        return age?.rawValue
        
    }
    
    let weight = HealthKitModels.bodyMass?.aggregationStyle.rawValue
    
    let gender = try? HealthKitModels.healthStore.biologicalSex().biologicalSex.rawValue
    
    
    func findingGender() -> Int {
        let value = try? HealthKitModels.healthStore.biologicalSex().biologicalSex.rawValue
        if value == 1 {
            _ = "female"
        }
        if value == 2 {
            _ = "male"
        }
        if value == 0 {
          // alert controller telling them to set their gender
        }
        else if value == 3 {
            _ = "other"
        }
    return value ?? 0
        // this is grabbing the raw value of gender from healthstore (which stores all the data that the user inputted in the health app), 1 for male, 2 for female, if its 3 it means its not set. Possibly display an alert controller asking them for their gender if it = 0
    }
}

