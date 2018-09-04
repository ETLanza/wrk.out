//
//  RestTimerController.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/1/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class RestTimerController {
    
    //MARK: - Shared Instance
    static let shared = RestTimerController()
    
    //MARK: - Properties
    var restTimer = RestTimer()
    
    //MARK: - Helper Functions
    func changeRestTimerLength(to seconds: TimeInterval) {
        restTimer.length = seconds
        restTimer.startLength = seconds
    }
    
    func toggleIsEnabled() {
        restTimer.isEnabled = !restTimer.isEnabled
    }
    
    func decreaseTimer() {
        if restTimer.length > 0 {
            restTimer.length = restTimer.length - 1
        } else {
            restTimer.length = restTimer.startLength
        }
    }
}
