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
    
    var observer: NSObjectProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        observer = NotificationCenter.default.addObserver(forName: .saveUserInfo, object: nil, queue: OperationQueue.main) { (notification) in
            let editInfoVC = notification.object as! EditInfoPopupViewController
            guard let name = editInfoVC.nameTF?.text, !name.isEmpty,
            let ageAsString = editInfoVC.ageTF.text, !ageAsString.isEmpty, let age = Int(ageAsString),
            let heightAsString = editInfoVC.heightTF.text, !heightAsString.isEmpty, let height = Double(heightAsString),
            let weightAsString = editInfoVC.weightTF.text, !weightAsString.isEmpty, let weight = Double(weightAsString),
            let gender = editInfoVC.genderTF.text, !gender.isEmpty,
            let user = UserController.shared.loggedInUser else { return }
            
            UserController.shared.update(user: user, name: name, age: age, height: height, weight: weight, gender: gender, completion: { (success) in
                if success {
                    DispatchQueue.main.async {                        
                    self.updateViews()
                    }
                }
            })
            
//            UserController.shared.loggedInUser.name = name
//            UserController.shared.loggedInUser?.age = age
//            UserController.shared.loggedInUser?.weight = weight
//            UserController.shared.loggedInUser?.height = height
//            UserController.shared.loggedInUser?.gender = gender
//            self.profileImage.image = editInfoVC.profilePopupImageView.image
        }
        updateViews()
    }
    
    func updateViews() {
        guard let loggedInUser = UserController.shared.loggedInUser else { return }
        self.nameLabel.text = loggedInUser.name
        self.ageLabel.text = String(loggedInUser.age)
        self.heightLabel.text = String(loggedInUser.height)
        self.weightLabel.text = String(loggedInUser.weight)
        self.genderLabel.text = loggedInUser.gender
    
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
            destinationVC.user = user
        }
    }
}
