// 
//  WorkoutExerciseViewController.swift
//  wrk.out
//
//  Created by Eric Lanza on 8/31/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class WorkoutExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var exercises: [Exercise] = SearchController.shared.excercises
    var filtered: [Exercise] = []
    weak var delegate: WorkoutExerciseViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var backgroundView: UIView!

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        if filtered.isEmpty == true {
            let excercises = SearchController.shared.excercises[indexPath.row]
            let categoryName = SearchController.shared.excercises[indexPath.row].category.name
            cell.textLabel?.text = excercises.name
            cell.detailTextLabel?.text = categoryName
        } else {
            cell.textLabel?.text = filtered[indexPath.row].name
            cell.detailTextLabel?.text = filtered[indexPath.row].category.name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered.isEmpty == true {
            return SearchController.shared.excercises.count
        } else {
            return filtered.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var exercise = exercises[indexPath.row]
        if !filtered.isEmpty {
            exercise = filtered[indexPath.row]
        }

        let liftName = exercise.name
        delegate?.selectedLift(name: liftName, sender: self)

        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        searchBar.addDoneButtonOnKeyboard()
    }

    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WorkoutExerciseViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text else { return }
        if searchTerm.isEmpty {
            filtered = []
            tableView.reloadData()
        } else {
            let exercises = SearchController.shared.excercises
            let filteredCategory = exercises.filter {$0.category.name.contains(searchTerm)}
            let filteredString = exercises.filter {$0.name.contains(searchTerm)}

            filtered = filteredCategory + filteredString
            tableView.reloadData()
        }
    }
}

protocol WorkoutExerciseViewControllerDelegate: class {
    func selectedLift(name: String, sender: WorkoutExerciseViewController)
}
