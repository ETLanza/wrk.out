//
//  PreviousWorkoutViewController.swift
//  wrk.out
//
//  Created by Eric Lanza on 9/16/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class PreviousWorkoutViewController: UIViewController {

    var workout: Workout?
    @IBOutlet weak var workoutDurationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        guard let workout = workout else { return }
        workoutDurationLabel.text = TimeStringFormatter.shared.timeString(time: workout.duration)
        navigationItem.title = workout.name
    }
}

extension PreviousWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout?.lifts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout?.lifts[section].liftsets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "previousLiftHeaderCell") as? PreviousLiftHeaderTableViewCell else { return nil }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "previousLiftSetCell", for: indexPath) as? PreviousLiftSetTableViewCell else { return UITableViewCell() }
        
        let lift = workout?.lifts[indexPath.section]
        let liftSet = lift!.liftsets[indexPath.row]
        
        cell.liftSetNumberLabel.text = "\(indexPath.row + 1)"
        cell.liftNameLabel.text = lift?.name
        cell.liftWeightLabel.text = "\(liftSet.weight)"
        cell.liftRepsLabel.text = "\(liftSet.reps)"
        
        return cell
    }
    
    
}
