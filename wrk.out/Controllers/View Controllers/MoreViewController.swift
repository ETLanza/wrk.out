//
//  MoreViewController.swift
//  wrk.out
//
//  Created by Sam on 8/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITextFieldDelegate {
   
    //MARK: - IBOutlets
    @IBOutlet weak var restTimerSwitch: UISwitch!
    @IBOutlet weak var numberOfSecondsTextField: UITextField!
    @IBOutlet weak var inSecondsLabel: UILabel!
    
    //MARK: - Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOfSecondsTextField.text = "\(Int(RestTimerController.shared.restTimer.startLength))"
        if RestTimerController.shared.restTimer.isEnabled {
            restTimerSwitch.isOn = true
            numberOfSecondsTextField.isHidden = false
            inSecondsLabel.isHidden = false
        } else {
            restTimerSwitch.isOn = false
        }
    }
    
    //MARK: - IBActions
    @IBAction func restTimerSwitchedON(_ sender: Any) {
        RestTimerController.shared.toggleIsEnabled()
        numberOfSecondsTextField.isHidden = !numberOfSecondsTextField.isHidden
        inSecondsLabel.isHidden = !inSecondsLabel.isHidden
        UserDefaults.standard.set(RestTimerController.shared.restTimer.isEnabled, forKey: "restTimerIsEnabled")
    }
    
    //MARK: - Helper Functions
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == numberOfSecondsTextField {
            guard let text = textField.text, let textAsInt = Int(text) else { return }
            let textAsTimeInterval = TimeInterval(exactly: textAsInt)
            RestTimerController.shared.changeRestTimerLength(to: textAsTimeInterval!)
            UserDefaults.standard.set(textAsTimeInterval, forKey: "restTimerLength")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
