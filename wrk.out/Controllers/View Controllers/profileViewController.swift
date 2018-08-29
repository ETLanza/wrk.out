//
//  profileViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var observer: NSObjectProtocol?
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        
        observer = NotificationCenter.default.addObserver(forName: .saveUserInfo,
                                                          object: nil,
                                                          queue: OperationQueue.main) { (notification) in
            let editInfoVC = notification.object as! editInfoPopupViewController
            self.nameLabel.text = editInfoVC.nameTF.text
            self.ageLabel.text = editInfoVC.ageTF.text
            self.weightLabel.text = editInfoVC.weightTF.text
            self.heightLabel.text = editInfoVC.hieghtTF.text
            self.genderLabel.text = editInfoVC.genderTF.text
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
}
