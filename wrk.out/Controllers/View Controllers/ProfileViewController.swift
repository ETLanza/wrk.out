//
//  ProfileViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var previousWorkoutTableView: UITableView!
    
    var observer: NSObjectProtocol?

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .saveUserInfo, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViews()
    }

    @objc func updateViews() {
        previousWorkoutTableView.reloadData()
        guard let loggedInUser = UserController.shared.loggedInUser else { return }
        self.nameLabel.text = loggedInUser.name
        self.ageLabel.text = String(loggedInUser.age)
        self.heightLabel.text = String(loggedInUser.height)
        self.weightLabel.text = String(loggedInUser.weight)
        self.genderLabel.text = loggedInUser.gender
        self.profileImage.image = loggedInUser.profileImage
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUserInfoSegue" {
            guard let destinationVC = segue.destination as? EditInfoPopupViewController,
            let user = UserController.shared.loggedInUser else { return }
            self.definesPresentationContext = true
            destinationVC.user = user
        } else if segue.identifier == "previousWorkoutSegue" {
            guard let destinationVC = segue.destination as? PreviousWorkoutViewController else { return }
            let index = previousWorkoutTableView.indexPathForSelectedRow
            let workout = WorkoutController.shared.workouts[index!.row]
            destinationVC.workout = workout
        }
    }
}

// MARK: - UITableView DataSource and Delegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentWorkoutsCell", for: indexPath)
        let workout = WorkoutController.shared.workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.detailTextLabel?.text = TimeStringFormatter.shared.timeString(time: workout.duration)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
