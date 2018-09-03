//
//  RestTimerController.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/1/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class RestTimerControlller {
    
    static let shared = RestTimerControlller()
    
    var restTimer = RestTimer()
//    var timer: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTimer), userInfo: nil, repeats: true)
    
    func changeRestTimerLength(to seconds: TimeInterval) {
        restTimer.length = seconds
    }
    
    @objc func decreaseTimer() {
        if restTimer.length > 0 {
            restTimer.length = restTimer.length - 1
        } else {
            
        }
    }
    
    
}
