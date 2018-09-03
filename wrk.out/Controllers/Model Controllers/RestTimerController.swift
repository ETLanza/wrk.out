//
//  RestTimerController.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/1/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class RestTimerControlller {
    
    //MARK: - Shared Instance
    static let shared = RestTimerControlller()
    
    //MARK: - Properties
    var restTimer = RestTimer()
    var timer: Timer?

    //MARK: - Helper Functions
    func changeRestTimerLength(to seconds: TimeInterval) {
        restTimer.length = seconds
        restTimer.startLength = seconds
    }
    
    func toggleIsEnabled() {
        restTimer.isEnabled = !restTimer.isEnabled
    }
    
    func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTimer), userInfo: nil, repeats: true)
    }
    
    @objc func decreaseTimer() {
        if restTimer.length > 0 {
            restTimer.length = restTimer.length - 1
        } else {
            timer?.invalidate()
            restTimer.length = restTimer.startLength
        }
    }
}
