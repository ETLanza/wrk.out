//
//  AddRoutineExerciseTableViewCell.swift
//  wrk.out
//
//  Created by Sam on 9/3/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class AddRoutineExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var addExercise: UIButton!
    weak var delegate: AddRoutineExerciseTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addExercise.roundCorners()
    }

    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        delegate?.addExerciseCellButtonTapped(self)
    }
}
protocol AddRoutineExerciseTableViewCellDelegate: class {
    func addExerciseCellButtonTapped(_ sender: AddRoutineExerciseTableViewCell)
}
