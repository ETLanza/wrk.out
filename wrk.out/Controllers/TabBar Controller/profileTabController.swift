//
//  profileTabController.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/22/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class profileTabController: UITabBarItem {
    
    var profileTab: UITabBarItem
    
    let profileTabSelectedImage = UIImage(named: "ProfileIconSelected.png")?.withRenderingMode(.alwaysOriginal)
    let profileTabDeselectedImage = UIImage(named: "ProfileIcon.png")?.withRenderingMode(.alwaysOriginal)
    TabBarItem = self.tabBar.items![0]
    TabBarItem.image = profileTabDeselectedImage
    TabBarItem.selectedImage = profileTabSelectedImage

}
