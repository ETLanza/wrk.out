//
//  LiftsetTableViewCell.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class LiftsetTableViewCell: UITableViewCell {
    
    var liftset: LiftSet?
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var liftNameCell: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
}

protocol LiftsetTableViewCellDelegate {
    func liftsetCellButtonTapped(_ sender: LiftsetTableViewCell)
}
