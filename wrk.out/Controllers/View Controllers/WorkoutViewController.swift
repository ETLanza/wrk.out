//
//  WorkoutViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import CloudKit

class WorkoutViewController: UIViewController {
    
    var workout: Workout?
    
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var popupVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func newWorkoutButtonTapped(_ sender: Any) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        WorkoutController.shared.createNewWorkoutWith(name: "New Workout") { (workout) in
            if let workout = workout {
                self.workout = workout
            }
        }
    }
    
    @IBAction func popupSwipedUp(_ sender: Any) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func popupSwippedDown(_ sender: Any) {
        bottomConstraint.constant = -515
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func endWorkoutButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        guard let workout = workout else { return }
        LiftController.shared.addLiftTo(workout: workout, name: "New Exercise") { (success) in
            if success {
                DispatchQueue.main.async {
                    self.popupTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func cancelWorkoutButtonTapped(_ sender: UIButton) {
        
    }
}

//MARK: - New Workout Drawer
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.lifts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.lifts[section].liftsets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftHeaderCell") as? LiftHeaderTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addSetCell") as? AddSetTableViewCell else { return UITableViewCell() }
        cell.addSetButton.tag = section
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftsetCell", for: indexPath) as? LiftsetTableViewCell else { return UITableViewCell() }
        
        guard let workout = workout else { return UITableViewCell() }
        let lift = workout.lifts[indexPath.section]
        cell.liftNameCell.text = lift.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension WorkoutViewController: AddSetTableViewCellDelegate {
    func addSetCellButtonTapped(_ sender: AddSetTableViewCell) {
        let section = sender.addSetButton.tag
        let lift = workout?.lifts[section]
        let lastLiftset = lift?.liftsets.last
        let newWeight = lastLiftset?.weight ?? 0
        let newReps = lastLiftset?.reps ?? 0
        LiftSetController.shared.addLiftset(toLift: lift!, weight: newWeight + 5, reps: newReps) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.popupTableView.reloadData()
                }
            }
        }
    }
}

