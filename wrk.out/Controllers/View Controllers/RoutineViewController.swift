//
//  RoutineViewController.swift
//  wrk.out
//
//  Created by Sam on 8/30/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController {
    
    var routine: Routine?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        RoutineController.shared.fetchRoutines { (success) in
            if success {
                RoutineController.shared.fetchLifts(completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "New routine", message: "What would you like your routine to be named?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New routine"
        }
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            var routineName = alertController.textFields?.first?.text ?? "New routine"
            if routineName == "" { routineName = "New routine" }
            
            RoutineController.shared.createRoutine(name: routineName) { (routine) in
                if let routine = routine {
                    self.routine = routine
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
extension RoutineViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return RoutineController.shared.routines.count
    }
    
    // TODO: Swipe to delete rows/sections
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let routine = RoutineController.shared.routines[indexPath.section]
            let lift = routine.routineLifts[indexPath.row]
            RoutineController.shared.deleteLift(lift: lift, routine: routine) { (success) in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .left)
                        tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseInRoutineCell", for: indexPath) as? RoutineTableViewCell else { return UITableViewCell() }
        let routine = RoutineController.shared.routines[indexPath.section]
        let lift = routine.routineLifts[indexPath.row]
        cell.exerciseNameLabel.text = lift.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoutineController.shared.routines[section].routineLifts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineHeaderCell") as? RoutineHeaderTableViewCell else { return UITableViewCell() }
        let routine = RoutineController.shared.routines[section]
        cell.routineName.text = routine.routineName
        cell.tag = section
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRoutineExerciseCell") as? AddRoutineExerciseTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.tag = section
        return cell
    }
    
    // Height for footer/header
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
extension RoutineViewController : AddRoutineExerciseTableViewCellDelegate {
    func addExerciseCellButtonTapped(_ sender: AddRoutineExerciseTableViewCell) {
        
        let section = sender.tag
        let storyboard = UIStoryboard(name: "Workouts", bundle: nil)
        guard let popupVC = storyboard.instantiateViewController(withIdentifier: "exerciseReuse") as? WorkoutExerciseViewController else { return }
        
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.delegate = self
        popupVC.view.tag = section
        
        self.definesPresentationContext = true
        self.present(popupVC, animated: true, completion: nil)
    }
}

extension RoutineViewController : WorkoutExerciseViewControllerDelegate {
    func selectedLift(name: String, sender: WorkoutExerciseViewController) {
        let index = sender.view.tag
        let routine = RoutineController.shared.routines[index]
        
        RoutineController.shared.createLift(name: name, routine: routine) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
