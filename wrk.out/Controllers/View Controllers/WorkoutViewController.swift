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
    
    //MARK: - Properties
    var workout: Workout?
    var timer: Timer?
    
    //MARK: - IBOutlets
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var workoutDurationLabel: UILabel!
    @IBOutlet weak var currentWorkoutNameLabel: UILabel!
    
    //MARK: - IBActions
    @IBAction func newWorkoutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new workout name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New Workout"
        }
        let startAlertAction = UIAlertAction(title: "Start", style: .default) { (_) in
            var workoutName = alertController.textFields?.first?.text ?? "New Workout"
            if workoutName == "" { workoutName = "New Workout" }
            WorkoutController.shared.createNewWorkoutWith(name: workoutName) { (workout) in
                if let workout = workout {
                    self.workout = workout
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
                        self.workoutDurationLabel.text = "0"
                        self.bottomConstraint.constant = 0
                        self.currentWorkoutNameLabel.text = workout.name
                        UIView.animate(withDuration: 0.3, animations: {
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(startAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true, completion: nil)
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
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        displayAddNoteAlert()
    }
    
    @IBAction func endWorkoutButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        displayEndWorkoutAlert()
    }
    
    @IBAction func addExerciseButtonTapped(_ sender: UIButton) {
        //NEEDS TO COME FROM THE EXERCISES TAB??????
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
        displayCancelWorkoutAlert()
    }
    
    //MARK: - Helper Functions
    func endWorkout() {
        DispatchQueue.main.async {
            self.bottomConstraint.constant = -612
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.workout = nil
                self.popupTableView.reloadData()
            }
            self.workoutDurationLabel.text = "00"
        }
    }
    
    @objc func increaseTimer() {
        guard let workout = workout else { return }
        workout.duration = workout.duration + 1
        let durationAsString = timeString(time: workout.duration)
        self.workoutDurationLabel.text = durationAsString
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours == 0 && minutes == 0 {
            return String(format:"%2i", seconds)
        } else if hours == 0 {
            return String(format:"%2i:%02i", minutes, seconds)
        } else {
            return String(format:"%2i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    func displayAddNoteAlert() {
        let addNoteAlertController = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
        addNoteAlertController.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let workout = self.workout {
                guard let note = addNoteAlertController.textFields?.first?.text else { return }
                WorkoutController.shared.modify(workout: workout, withName: workout.name, note: note, duration: workout.duration, completion: { (success) in
                    if success {
                        workout.note = note
                    }
                })
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addNoteAlertController.addAction(cancelAction)
        addNoteAlertController.addAction(saveAction)
        self.present(addNoteAlertController, animated: true, completion: nil)
    }
    
    func displayEndWorkoutAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to finish your current workout?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { (_) in
            guard let workout = self.workout else { return }
            WorkoutController.shared.modify(workout: workout, withName: workout.name, note: workout.note, duration: workout.duration, completion: { (success) in
                if success {
                    self.endWorkout()
                }
            })
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func displayCancelWorkoutAlert() {
        let alertController = UIAlertController(title: "Are you sure you want to cancel your current workout?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { (_) in
            guard let workout = self.workout else { return }
            WorkoutController.shared.delete(workout: workout, completion: { (success) in
                if success {
                    self.endWorkout()
                }
            })
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
        cell.setNumberLabel.text = "\(indexPath.row + 1)"
        cell.delegate = self
        
        return cell
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

//MARK: - AddSetTableViewCellDelegate
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

//MARK: - LiftHeaderTableViewCellDelegate
extension WorkoutViewController: LiftHeaderTableViewCellDelegate {
    func moreButtonPressed(_ sender: LiftHeaderTableViewCell) {
        guard let workout = self.workout else { return }
        let section = sender.tag
        
        func displayMoreAlertController() {
            let moreAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            let renameLiftAlertAction = UIAlertAction(title: "Rename Lift", style: .default) { (_) in
                displayRenameLiftAlert()
            }
            
            let removeLiftAlertAction = UIAlertAction(title: "Remove Lift", style: .default) { (_) in
                displayRemoveLiftAlert()
            }
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            moreAlertController.addAction(renameLiftAlertAction)
            moreAlertController.addAction(removeLiftAlertAction)
            moreAlertController.addAction(cancelAlertAction)
            
            present(moreAlertController, animated: true, completion: nil)
        }
        
        func displayRenameLiftAlert() {
            let renameLiftAlertController = UIAlertController(title: "Rename Lift", message: "Enter your new lift name", preferredStyle: .alert)
            renameLiftAlertController.addTextField { (textField) in
                textField.placeholder = "New name"
            }
            let doneAlertAction = UIAlertAction(title: "Done", style: .default) { (_) in
                let lift = workout.lifts[section]
                var nameText = renameLiftAlertController.textFields?.first?.text ?? "Lift"
                if nameText == "" { nameText = lift.name }
                LiftController.shared.modify(lift: lift, withName: nameText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            lift.name = nameText
                            self.popupTableView.reloadData()
                        }
                    }
                })
            }
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            renameLiftAlertController.addAction(doneAlertAction)
            renameLiftAlertController.addAction(cancelAlertAction)
            
            present(renameLiftAlertController, animated: true, completion: nil)
        }
        
        func displayRemoveLiftAlert() {
            let removeExerciseAlertController = UIAlertController(title: "Are you sure you want to remove this lift?", message: nil, preferredStyle: .alert)
            
            let cancelExercise = UIAlertAction(title: "Remove Lift", style: .destructive) { (alertAction) in
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
            
            removeExerciseAlertController.addAction(cancelExercise)
            removeExerciseAlertController.addAction(returnAction)
            
            present(removeExerciseAlertController, animated: true, completion: nil)
        }
        displayMoreAlertController()
    }
}

//MARK: - LiftsetTableViewCellDelegate
extension WorkoutViewController: LiftsetTableViewCellDelegate {
    func liftsetCellButtonTapped(_ sender: LiftsetTableViewCell) {
        sender.doneButton.isHidden = true
    }
}

