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
