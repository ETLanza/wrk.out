//
//  editInfoPopupViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class editInfoPopupViewController: UIViewController {

    @IBOutlet var EditInfoPopupVIew: UIView!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
