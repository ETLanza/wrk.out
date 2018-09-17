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
    
    // MARK: - Properties
    var workout: Workout?
    var durationTimer: Timer?
    var restTimer: Timer?
    
    // MARK: - IBOutlets
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var workoutDurationLabel: UILabel!
    @IBOutlet weak var currentWorkoutNameLabel: UILabel!
    @IBOutlet weak var previousWorkoutTableView: UITableView!
    @IBOutlet weak var restTimerLabel: UILabel!
    @IBOutlet weak var endWorkoutButton: UIButton!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var cancelWorkoutButton: UIButton!
    
    @IBOutlet weak var popupViewOpenedConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupViewMinimizedConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    @IBAction func newWorkoutButtonTapped(_ sender: Any) {
        displayNewWorkoutAlert()
    }
    
    @IBAction func popupSwipedUp(_ sender: Any) {
        popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 999)
        popupViewMinimizedConstraint.priority = UILayoutPriority(rawValue: 1)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func popupSwippedDown(_ sender: Any) {
        popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 1)
        popupViewMinimizedConstraint.priority = UILayoutPriority(rawValue: 999)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        displayAddNoteAlert()
    }
    
    @IBAction func endWorkoutButtonTapped(_ sender: UIButton) {
        displayEndWorkoutAlert()
        previousWorkoutTableView.reloadData()
    }
    
    @IBAction func cancelWorkoutButtonTapped(_ sender: UIButton) {
        displayCancelWorkoutAlert()
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        guard let user = UserController.shared.loggedInUser else { return }
        WorkoutController.shared.fetchAllWorkoutsFor(user: user) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.previousWorkoutTableView.reloadData()
                }
                WorkoutController.shared.workouts.forEach({ (workout) in
                    LiftController.shared.fetchAllLiftsFor(workout: workout, completion: { (success) in
                        if success {
                            workout.lifts.forEach({ (lift) in
                                LiftSetController.shared.fetchAllLiftsetsFor(lift: lift, completion: { (success) in
                                    if success {
                                    }
                                })
                            })
                        }
                    })
                })
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func setUpViews() {
        addExerciseButton.roundCorners()
        endWorkoutButton.roundCorners()
        cancelWorkoutButton.roundCorners()
        popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 800)
    }
  
    func displayNewWorkoutAlert() {
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
                        self.durationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
                        self.workoutDurationLabel.text = "0"
                        self.popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 999)
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
    
    func newWorkoutFromRoutine(named name: String) {
        self.durationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.increaseTimer), userInfo: nil, repeats: true)
        self.workoutDurationLabel.text = "0"
        self.popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 999)
        self.currentWorkoutNameLabel.text = name
        self.workout?.lifts.forEach({ (lift) in
            lift.liftsets = []
        })
        self.workout?.lifts.forEach({ (lift) in
            LiftSetController.shared.addLiftset(toLift: lift, weight: 0, reps: 0, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.popupTableView.reloadData()
                    }
                }
            })
        })
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: TableViewFooter Buttons
    
    func endWorkout() {
        durationTimer?.invalidate()
        DispatchQueue.main.async {
            self.popupViewMinimizedConstraint.priority = UILayoutPriority(rawValue: 1)
            self.popupViewOpenedConstraint.priority = UILayoutPriority(rawValue: 2)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.workout = nil
                self.popupTableView.reloadData()
            }
        }
    }
    
    func displayAddNoteAlert() {
        let alertTitle = workout?.note == "" ? "Add Note" : "Edit Note"
        let addNoteAlertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        addNoteAlertController.addTextField(configurationHandler: nil)
        guard let workout = workout else { return }
        if workout.note != "" { addNoteAlertController.textFields?.first?.text = workout.note }
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
    
    // MARK: Duration Timer
    @objc func increaseTimer() {
        guard let workout = workout else { return }
        workout.duration = workout.duration + 1
        let durationAsString = timeString(time: workout.duration)
        self.workoutDurationLabel.text = durationAsString
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours == 0 && minutes == 0 {
            return String(format: "%2i", seconds)
        } else if hours == 0 {
            return String(format: "%2i:%02i", minutes, seconds)
        } else {
            return String(format: "%2i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    // MARK: RestTimer
    @objc func deacreaseTimer() {
        RestTimerController.shared.decreaseTimer()
        let restTimeAsString = timeString(time: RestTimerController.shared.restTimer.length)
        self.restTimerLabel.text = restTimeAsString
        if RestTimerController.shared.restTimer.length == 0 {
            restTimer?.invalidate()
            restTimerLabel.isHidden = true
            displayEndRestAlert()
            RestTimerController.shared.changeRestTimerLength(to: RestTimerController.shared.restTimer.startLength)
        }
    }
    
    func displayEndRestAlert() {
        let alertController = UIAlertController(title: "Rest Time is up!", message: "Get Lifting", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Naviagtion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExerciseSegue" {
            let destinationVC = segue.destination as? WorkoutExerciseViewController
            self.definesPresentationContext = true
            destinationVC?.delegate = self
        }
        
        if segue.identifier == "previousWorkoutSegue" {
            let destinationVC = segue.destination as? PreviousWorkoutViewController
            let index = previousWorkoutTableView.indexPathForSelectedRow
            let workout = WorkoutController.shared.workouts[index!.row]
            destinationVC?.workout = workout
        }
    }
}

// MARK: - New Workout Drawer
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == popupTableView {
            return workout?.lifts.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popupTableView {
            return workout?.lifts[section].liftsets.count ?? 0
        } else {
            return WorkoutController.shared.workouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == popupTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftHeaderCell") as? LiftHeaderTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.tag = section
            
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == popupTableView {
            return 26
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if tableView == popupTableView {
            return 26
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == popupTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addSetCell") as? AddSetTableViewCell else { return UITableViewCell() }
            cell.addSetButton.tag = section
            cell.delegate = self
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == popupTableView {
            return 32
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if tableView == popupTableView {
            return 32
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popupTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "liftsetCell", for: indexPath) as? LiftsetTableViewCell else { return UITableViewCell() }
            
            guard let workout = workout else { return UITableViewCell() }
            let lift = workout.lifts[indexPath.section]
            cell.liftset = lift.liftsets[indexPath.row]
            cell.liftNameCell.text = lift.name
            cell.repTextField.text = "\(lift.liftsets[indexPath.row].reps)"
            cell.weightTextField.text = "\(lift.liftsets[indexPath.row].weight)"
            cell.setNumberLabel.text = "\(indexPath.row + 1)"
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "previousWorkoutCell", for: indexPath)
            
            let workout = WorkoutController.shared.workouts[indexPath.row]
            
            cell.textLabel?.text = workout.name
            cell.detailTextLabel?.text = timeString(time: workout.duration)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == popupTableView {
                if let workout = workout {
                    let lift = workout.lifts[indexPath.section]
                    let liftset = lift.liftsets[indexPath.row]
                    LiftSetController.shared.delete(liftset: liftset, fromLift: lift) { (success) in
                        if success {
                            DispatchQueue.main.async {
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                tableView.reloadData()
                            }
                        }
                    }
                }
            } else {
                let workout = WorkoutController.shared.workouts[indexPath.row]
                WorkoutController.shared.delete(workout: workout) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - AddSetTableViewCellDelegate
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

// MARK: - LiftHeaderTableViewCellDelegate
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
            
            let cancelExercise = UIAlertAction(title: "Remove Lift", style: .destructive) { (_) in
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

// MARK: - LiftsetTableViewCellDelegate
extension WorkoutViewController: LiftsetTableViewCellDelegate {
    func textFieldDidEndEditing(_ sender: LiftsetTableViewCell, textField: UITextField) {
        guard let liftset = sender.liftset else { return }
        if textField.tag == 1 {
            guard let weightAsString = textField.text, let weight = Double(weightAsString) else { return }
            LiftSetController.shared.update(liftset: liftset, withWeight: weight, andReps: liftset.reps)
        } else if textField.tag == 2 {
            guard let repsAsString = textField.text, let reps = Int(repsAsString) else { return }
            LiftSetController.shared.update(liftset: liftset, withWeight: liftset.weight, andReps: reps)
        }
    }
    
    func liftsetCellButtonTapped(_ sender: LiftsetTableViewCell) {
        if sender.doneButton.titleLabel?.text == "Done" {
            sender.doneButton.setTitle("√", for: .normal)
            if RestTimerController.shared.restTimer.isEnabled {
                let restTimeText = timeString(time: RestTimerController.shared.restTimer.length)
                restTimerLabel.text = restTimeText
                restTimerLabel.isHidden = false
                restTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(deacreaseTimer), userInfo: nil, repeats: true)
            }
        } else {
            sender.doneButton.setTitle("Done", for: .normal)
            restTimer?.invalidate()
            restTimerLabel.isHidden = true
            RestTimerController.shared.restTimer.length = RestTimerController.shared.restTimer.startLength
        }
    }
}

extension WorkoutViewController: WorkoutExerciseViewControllerDelegate {
    func selectedLift(name: String, sender: WorkoutExerciseViewController) {
        if let workout = workout {
            LiftController.shared.addLiftTo(workout: workout, name: name) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.popupTableView.reloadData()
                    }
                }
            }
        }
    }
}
