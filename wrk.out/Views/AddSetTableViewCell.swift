//
//  AddSetTableViewCell.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class AddSetTableViewCell: UITableViewCell {

    @IBOutlet weak var addSetButton: UIButton!
    weak var delegate: AddSetTableViewCellDelegate?

    @IBAction func addSetButtonPressed(_ sender: UIButton) {
        delegate?.addSetCellButtonTapped(self)
    }

}
protocol AddSetTableViewCellDelegate: class {
    func addSetCellButtonTapped(_ sender: AddSetTableViewCell)
}
