//
//  WorkoutViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import CloudKit

class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var popupVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func newWorkoutButtonTapped(_ sender: Any) {
        
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func popupSwipedUp(_ sender: Any) {
    
    
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func popupSwippedDown(_ sender: Any) {
        
        bottomConstraint.constant = -515
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
}

