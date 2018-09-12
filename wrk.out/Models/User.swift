//
//  user.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/23/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import CloudKit

class User: Equatable {

    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var gender: String
    var profileImageAsData: Data?
    var profileImage: UIImage? {
        guard let profileImageAsData = profileImageAsData else { return nil }
        let profileImage = UIImage(data: profileImageAsData)
        return profileImage
    }
//    var profileImage: UIImage
    var ckRecordID: CKRecordID
    let appleUserReference: CKReference

    fileprivate var temporaryPhotoURL: URL {

        // Must write to temporary directory to be able to pass image file path url to CKAsset

        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")

        guard let profileImageAsData = profileImageAsData else { return fileURL }

        try? profileImageAsData.write(to: fileURL, options: [.atomic])

        return fileURL
    }

    init(name: String, age: Int, height: Double, weight: Double, gender: String, profileImageAsData: Data?, appleUserReference: CKReference) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
        self.profileImageAsData = profileImageAsData
        self.appleUserReference = appleUserReference
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Keys.User.name] as? String,
            let age = ckRecord[Keys.User.age] as? Int,
            let height = ckRecord[Keys.User.height] as? Double,
            let weight = ckRecord[Keys.User.weight] as? Double,
            let gender = ckRecord[Keys.User.gender] as? String,
            let appleUserReference = ckRecord[Keys.User.appleUserReference] as? CKReference else { return nil }

        let profileImageAsset = ckRecord[Keys.User.profileImage] as? CKAsset

        if profileImageAsset != nil {
        let profileImageAssetAsData = try? Data(contentsOf: (profileImageAsset?.fileURL)!)
            self.profileImageAsData = profileImageAssetAsData
        }

        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.gender = gender
        self.appleUserReference = appleUserReference

        ckRecordID = ckRecord.recordID

    }

    // MARK: - Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: Keys.User.type, recordID: user.ckRecordID)

        let profileImageAsset = CKAsset(fileURL: user.temporaryPhotoURL)

        self.setValue(user.age,
                      forKey: Keys.User.age)
        self.setValue(user.name,
                      forKey: Keys.User.name)
        self.setValue(user.height,
                      forKey: Keys.User.height)
        self.setValue(user.weight,
                      forKey: Keys.User.weight)
        self.setValue(user.gender,
                      forKey: Keys.User.gender)
        self.setValue(profileImageAsset, forKey: Keys.User.profileImage)
        self.setValue(user.appleUserReference, forKey: Keys.User.appleUserReference)
    }
}
