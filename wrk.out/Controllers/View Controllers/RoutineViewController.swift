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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseInRoutineCell", for: indexPath) as? RoutineTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoutineController.shared.routine?.routineLifts.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineHeaderCell") as? RoutineHeaderTableViewCell else { return UITableViewCell() }
        
        cell.tag = section
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRoutineExerciseCell") as? AddRoutineExerciseTableViewCell else { return UITableViewCell() }
        cell.tag = section
        return cell
    }
}
