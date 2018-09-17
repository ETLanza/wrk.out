//
//  ExcerciseViewController.swift
//  wrk.out
//
//  Created by Sam on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//
import UIKit

class ExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var results: Exercise?
    var category: Category?
    var filtered: [Exercise] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            if segue.identifier == "toExercisePopup" {
                self.definesPresentationContext = true
                if let exercisePopVC = segue.destination as? ExerciseViewControllerPopup {
                    if filtered.isEmpty == true {
                        exercisePopVC.testText =  SearchController.shared.excercises[selectedRow].description
                    } else {
                        exercisePopVC.testText = filtered[selectedRow].description
                    }
                }
            }
        }
    }
}

extension ExerciseViewController: UISearchBarDelegate {
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
            print(filtered)
        }
    }
}
