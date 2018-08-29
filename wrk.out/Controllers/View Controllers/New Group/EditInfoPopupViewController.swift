//
//  EditInfoPopupViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class EditInfoPopupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //TF Outlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
    var user: User?
    
    //popup outlets
    @IBOutlet var EditInfoPopupVIew: UIView!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //actions
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        if UserController.shared.loggedInUser == nil {
            guard let name = nameTF.text, !name.isEmpty,
                let ageAsString = ageTF.text, !ageAsString.isEmpty, let age = Int(ageAsString),
                let heightAsString = heightTF.text, !heightAsString.isEmpty, let height = Double(heightAsString),
                let weightAsString = weightTF.text, !weightAsString.isEmpty, let weight = Double(weightAsString),
                let gender = genderTF.text, !gender.isEmpty else { return }
            UserController.shared.createUserWith(name: name, age: age, height: height, weight: weight, gender: gender) { (success) in
                if success {
                    let sb = UIStoryboard(name: "TabBar", bundle: nil)
                    let tabBarController = sb.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(tabBarController, animated: true, completion: nil)
                }
            }
        } else {
            NotificationCenter.default.post(name: .saveUserInfo, object: self)
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //Change Photo
    @IBOutlet weak var profilePopupImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let loggedInUser = user {
            self.nameTF.text = loggedInUser.name
            self.ageTF.text = String(loggedInUser.age)
            self.heightTF.text = String(loggedInUser.height)
            self.weightTF.text = String(loggedInUser.weight)
            self.genderTF.text = loggedInUser.gender
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Where From?", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePopupImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
