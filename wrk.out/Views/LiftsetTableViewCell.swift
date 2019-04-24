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
    weak var delegate: LiftsetTableViewCellDelegate?

    override func awakeFromNib() {
        weightTextField.delegate = self
        repTextField.delegate = self
        doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        liftNameCell.adjustsFontSizeToFitWidth = true
        weightTextField.addDoneButtonOnKeyboard()
        repTextField.addDoneButtonOnKeyboard()
    }

    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var liftNameCell: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.liftsetCellButtonTapped(self)
    }
}

extension LiftsetTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self, textField: textField)
    }
}

protocol LiftsetTableViewCellDelegate: class {
    func liftsetCellButtonTapped(_ sender: LiftsetTableViewCell)
    func textFieldDidEndEditing(_ sender: LiftsetTableViewCell, textField: UITextField)
}
