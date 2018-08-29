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
    var timer: Timer?
    
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var workoutDurationLabel: UILabel!
    
    //    var popupVisible = false
    
    @IBAction func newWorkoutButtonTapped(_ sender: Any) {
        WorkoutController.shared.createNewWorkoutWith(name: "New Workout") { (workout) in
            if let workout = workout {
                self.workout = workout
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
                    self.workoutDurationLabel.text = "0"
                    self.bottomConstraint.constant = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
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
        timer?.invalidate()
        endWorkoutDisplay()
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
        WorkoutController.shared.workouts.removeLast()
        endWorkoutDisplay()
    }
    
    //MARK: - Helper Functions
    func endWorkout() {
        bottomConstraint.constant = -612
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.workout = nil
            self.popupTableView.reloadData()
        }
        self.workoutDurationLabel.text = "0"
    }
    
    @objc func increaseTimer() {
        guard let workout = workout else { return }
        workout.duration = workout.duration! + 1
        self.workoutDurationLabel.text = "\(workout.duration!)"
    }
    
    func endWorkoutDisplay() {
        let alertController = UIAlertController(title: "Are you sure you want to end your current workout?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { (_) in
            self.endWorkout()
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
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
        
        cell.delegate = self
        cell.tag = section
        
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
        cell.repTextField.text = "\(lift.liftsets[indexPath.row].reps)"
        cell.weightTextField.text = "\(lift.liftsets[indexPath.row].weight)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let workout = workout {
                let lift = workout.lifts[indexPath.section]
                let liftset = lift.liftsets[indexPath.row]
                LiftSetController.shared.delete(liftset: liftset, fromLift: lift) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.popupTableView.reloadData()
                        }
                    }
                }
            }
        }
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

extension WorkoutViewController: LiftHeaderTableViewCellDelegate {
    func moreButtonPressed(_ sender: LiftHeaderTableViewCell) {
        let section = sender.tag
        let alertController = UIAlertController(title: "HELLO", message: nil, preferredStyle: .alert)
        
        let cancelExercise = UIAlertAction(title: "Remove Exercise", style: .destructive) { (alertAction) in
            guard let workout = self.workout else { return }
            let lift = workout.lifts[section]
            LiftController.shared.delete(lift: lift, fromWorkout: workout, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.popupTableView.reloadData()
                    }
                }
            })
        }
        
        let returnAction = UIAlertAction(title: "Return", style: .default, handler: nil)
        
        alertController.addAction(cancelExercise)
        alertController.addAction(returnAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}

