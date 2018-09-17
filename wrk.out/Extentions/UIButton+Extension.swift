//
//  UIButton+Extension.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/16/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

extension UIButton {
    
    func roundCorners() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
}
