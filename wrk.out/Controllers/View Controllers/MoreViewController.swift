//
//  MoreViewController.swift
//  wrk.out
//
//  Created by Sam on 8/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
   
    @IBOutlet weak var restTimerSwitch: UISwitch!
    @IBOutlet weak var secondsTF: UITextField!
    
    @IBAction func restTimerSwitchedOn(_ sender: Any) {
        
        if restTimerSwitch.isOn {
            secondsTF.isHidden = false
        } else {
            secondsTF.isHidden = true
        }
    }
}
