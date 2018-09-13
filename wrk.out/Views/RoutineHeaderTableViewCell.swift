//
//  RoutineHeaderTableViewCell.swift
//  wrk.out
//
//  Created by Sam on 9/3/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class RoutineHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var routineName: UILabel!

    weak var delegate: RoutineHeaderTableViewCellDelegate?
    @IBAction func ellipsisButtonTapped(_ sender: Any) {
        delegate?.ellipsisButtonTapped(self)
    }
}

protocol RoutineHeaderTableViewCellDelegate: class {
    func ellipsisButtonTapped(_ sender: RoutineHeaderTableViewCell)
}
