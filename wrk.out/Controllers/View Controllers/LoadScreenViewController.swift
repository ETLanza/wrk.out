//
//  LoadScreenViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/29/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class LoadScreenViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
      
        UserController.shared.fetchUserFromCloudKit { (success) in
            DispatchQueue.main.async {
            if success == true {
                let sb = UIStoryboard(name: "TabBar", bundle: nil)
                let tabBarController = sb.instantiateViewController(withIdentifier: "TabBarController")
                self.present(tabBarController, animated: true, completion: nil)
                }
            }
        }
        
    }
    


}
