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
    //    let exercises = SearchController.shared.excercises
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        let excercises = SearchController.shared.excercises[indexPath.row]
        let categoryName = SearchController.shared.excercises[indexPath.row].category.name
        
        cell.textLabel?.text = excercises.name
        cell.detailTextLabel?.text = categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchController.shared.excercises.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        
        SearchController.getWorkouts { (exercises) in
            guard exercises != nil else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            if segue.identifier == "toExercisePopup" {
               if let exercisePopVC = segue.destination as? ExerciseViewControllerPopup {
                    
                exercisePopVC.testText =  SearchController.shared.excercises[selectedRow].description
                }
            }
        }
    }
}

extension ExerciseViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
    }
}
