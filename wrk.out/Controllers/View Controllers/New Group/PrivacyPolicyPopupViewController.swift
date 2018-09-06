//
//  privacyPolicyPopupViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class PrivacyPolicyPopupViewController: UIViewController {
    
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
  
}
