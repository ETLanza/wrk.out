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
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .saveUserInfo, object: nil)
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = (self.profileImage.frame.width / 2)
        profileImage.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
    
    @objc func updateViews() {
        guard let loggedInUser = UserController.shared.loggedInUser else { return }
        self.nameLabel.text = loggedInUser.name
        self.ageLabel.text = String(loggedInUser.age)
        self.heightLabel.text = String(loggedInUser.height)
        self.weightLabel.text = String(loggedInUser.weight)
        self.genderLabel.text = loggedInUser.gender
        self.profileImage.image = loggedInUser.profileImage
        
    
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
