//
//  ExcerciseViewController.swift
//  wrk.out
//
//  Created by Sam on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//
import UIKit

class ExcercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var results: Exercise?
    var category: Category?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        let excercises = SearchController.shared.excercises[indexPath.row]
//        let categoryName = SearchController.shared.category[indexPath.row]
        
        cell.textLabel?.text = excercises.name
//        cell.detailTextLabel?.text = categoryName.name
        
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
            guard let exercises = exercises else { return }
            exercises.forEach { print($0.name) }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ExcercisesViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
    }
}
