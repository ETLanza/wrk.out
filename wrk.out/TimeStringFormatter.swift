//
//  TimeStringFormatter.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/17/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class TimeStringFormatter {
    
    static let shared = TimeStringFormatter()
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours == 0 && minutes == 0 {
            return String(format: "%2i", seconds)
        } else if hours == 0 {
            return String(format: "%2i:%02i", minutes, seconds)
        } else {
            return String(format: "%2i:%02i:%02i", hours, minutes, seconds)
        }
    }
}
