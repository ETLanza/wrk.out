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
    @IBOutlet weak var popupView: UIView!
    @IBAction func backgroundButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var results: Exercise?
    var testText: String?

    @IBOutlet weak var descriptionLabel: UILabel!

//        func testingTrimming(_: String)->String {
//            let newString = testText?.replacingOccurrences(of: "[</p>, <p>, <ul>, </ul>, <li>, </li>, <em>, </em>]",  with: "")
//
//        }

    // TODO: Clean this up

    func TrimmingHTMLFromLabel(_: String) -> String {
        let trimString1 = testText?.replacingOccurrences(of: "<p>", with: "")
        let trimString2 = trimString1?.replacingOccurrences(of: "</p>", with: "")
        let trimString3 = trimString2?.replacingOccurrences(of: "<ul>", with: "")
        let trimString4 = trimString3?.replacingOccurrences(of: "<li>", with: "")
        let trimString5 = trimString4?.replacingOccurrences(of: "</li>", with: "")
        let trimString6 = trimString5?.replacingOccurrences(of: "</ul>", with: "")
        let trimString7 = trimString6?.replacingOccurrences(of: "<em>", with: "")
        let trimString8 = trimString7?.replacingOccurrences(of: "</em>", with: "")
        let trimString9 = trimString8?.replacingOccurrences(of: "<ol>", with: "")
        let trimString10 = trimString9?.replacingOccurrences(of: "</ol>", with: "")
        return trimString10!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = TrimmingHTMLFromLabel(testText!)
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
    }
}
