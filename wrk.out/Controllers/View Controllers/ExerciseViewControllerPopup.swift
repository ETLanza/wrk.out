//
//  ExerciseViewControllerPopup.swift
//  wrk.out
//
//  Created by Sam on 8/28/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class ExerciseViewControllerPopup: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBAction func backgroundButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    var results: Exercise?
    var testText: String?
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func TrimmingHTMLFromLabel(_: String)->String {
        let trimString1 = testText?.replacingOccurrences(of: "<p>", with: "")
        let trimString2 = trimString1?.replacingOccurrences(of: "</p>", with: "")
        return trimString2!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = TrimmingHTMLFromLabel(testText!)
    }
}
