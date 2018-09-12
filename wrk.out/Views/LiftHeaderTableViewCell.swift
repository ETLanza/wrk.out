//
//  LiftHeaderTableViewCell.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class LiftHeaderTableViewCell: UITableViewCell {

    weak var delegate: LiftHeaderTableViewCellDelegate?

    @IBAction func moreButtonPressed(_ sender: UIButton) {
        delegate?.moreButtonPressed(self)
    }
}

protocol LiftHeaderTableViewCellDelegate: class {
    func moreButtonPressed(_ sender: LiftHeaderTableViewCell)
}
