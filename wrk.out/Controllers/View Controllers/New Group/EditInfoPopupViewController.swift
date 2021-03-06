//
//  EditInfoPopupViewController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/27/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class EditInfoPopupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak fileprivate var nameTF: UITextField!
    @IBOutlet weak public var ageTF: UITextField!
    @IBOutlet weak public var weightTF: UITextField!
    @IBOutlet weak public var heightTF: UITextField!
    @IBOutlet weak public var genderTF: UITextField!
    @IBOutlet weak var profileImagePopupView: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    
    var user: User?
    var profileImageAsData: Data?
    //popup outlets


    //actions
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let name = nameTF.text, !name.isEmpty,
            let ageAsString = ageTF.text, !ageAsString.isEmpty, let age = Int(ageAsString),
            let heightAsString = heightTF.text, !heightAsString.isEmpty, let height = Double(heightAsString),
            let weightAsString = weightTF.text, !weightAsString.isEmpty, let weight = Double(weightAsString),
            let gender = genderTF.text, !gender.isEmpty else { return }
        if UserController.shared.loggedInUser == nil {
            UserController.shared.createUserWith(name: name, age: age, height: height, weight: weight, gender: gender, profileImageAsData: profileImageAsData) { (success) in
                if success {
                    DispatchQueue.main.async {
                        let sb = UIStoryboard(name: "TabBar", bundle: nil)
                        let tabBarController = sb.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(tabBarController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            guard let loggedInUser = UserController.shared.loggedInUser else { return }
            UserController.shared.update(user: loggedInUser, name: name, age: age, height: height, weight: weight, gender: gender, profileImageAsData: profileImageAsData) { (success) in
                if success {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .saveUserInfo, object: self)
                        self.dismiss(animated: true)
                    }
                }
            }
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
        changePhotoButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    func updateViews() {
        if let loggedInUser = user {
            self.nameTF.text = loggedInUser.name
            self.ageTF.text = String(loggedInUser.age)
            self.heightTF.text = String(loggedInUser.height)
            self.weightTF.text = String(loggedInUser.weight)
            self.genderTF.text = loggedInUser.gender
            self.profileImagePopupView.image = loggedInUser.profileImage
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }

        ageTF.addDoneButtonOnKeyboard()
        heightTF.addDoneButtonOnKeyboard()
        weightTF.addDoneButtonOnKeyboard()
        genderTF.addDoneButtonOnKeyboard()
        saveChangesButton.roundCorners()
        scrollView.layer.cornerRadius = 20
        scrollView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true

        guard let loggedInUser = UserController.shared.loggedInUser,
            let profileImage = loggedInUser.profileImage else { return }
        self.profileImageAsData = UIImagePNGRepresentation(profileImage)
    }

    @IBAction func changePhoto(_ sender: Any) {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        let actionSheet = UIAlertController(title: "Where From?", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)

        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let profileImageAsData = UIImagePNGRepresentation(image)
        self.profileImageAsData = profileImageAsData

        profilePopupImageView.image = image

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTF:
            ageTF.becomeFirstResponder()
        case ageTF:
            weightTF.becomeFirstResponder()
        case weightTF:
            heightTF.becomeFirstResponder()
        case heightTF:
            genderTF.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
