//
//  FooterTableViewCell.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
    
    @IBAction func addExerciseButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func endWorkoutButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelWorkoutButtonPressed(_ sender: UIButton) {
    }
}

protocol FooterTableViewCellDelegate {
    func footerTableCellButtonTapped(_ sender: FooterTableViewCell)
}
