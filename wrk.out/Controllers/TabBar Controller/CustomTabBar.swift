//
//  CustomTabBar.swift
//  wrk.out
//
//  Created by John Cody Thompson on 8/22/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    var TabBarItem = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        UITabBar.appearance().barTintColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 90)
        
        
        let profileTabSelectedImage = UIImage(named: "ProfileIconSelected.png")?.withRenderingMode(.alwaysOriginal)
        let profileTabDeselectedImage = UIImage(named: "ProfileIcon.png")?.withRenderingMode(.alwaysOriginal)
        TabBarItem = self.tabBar.items![0]
        TabBarItem.image = profileTabDeselectedImage
        TabBarItem.selectedImage = profileTabSelectedImage
        
        let routinesTabSelectedImage = UIImage(named: "RoutinesIconSelected.png")?.withRenderingMode(.alwaysOriginal)
        let routinesTabDeselectedImage = UIImage(named: "RoutinesIcon.png")?.withRenderingMode(.alwaysOriginal)
        TabBarItem = self.tabBar.items![1]
        TabBarItem.image = routinesTabDeselectedImage
        TabBarItem.selectedImage = routinesTabSelectedImage

        let workoutsTabSelectedImage = UIImage(named: "WorkoutsIconSelected.png")?.withRenderingMode(.alwaysOriginal)
        let workoutsTabDeselectedImage = UIImage(named: "WorkoutsIcon.png")?.withRenderingMode(.alwaysOriginal)
        TabBarItem = self.tabBar.items![2]
        TabBarItem.image = workoutsTabDeselectedImage
        TabBarItem.selectedImage = workoutsTabSelectedImage
        
        let exeecisesTabSelectedImage = UIImage(named: "ExercisesIconSelected.png")?.withRenderingMode(.alwaysOriginal)
        let exercisesTabDeselectedImage = UIImage(named: "ExercisesIcon.png")?.withRenderingMode(.alwaysOriginal)
        TabBarItem = self.tabBar.items![3]
        TabBarItem.image = exercisesTabDeselectedImage
        TabBarItem.selectedImage = exeecisesTabSelectedImage
        
        let moreTabSelectedImage = UIImage(named: "MoreIconSelected.png")?.withRenderingMode(.alwaysOriginal)
        let moreTabDeselectedImage = UIImage(named: "MoreIcon.png")?.withRenderingMode(.alwaysOriginal)
        TabBarItem = self.tabBar.items![4]
        TabBarItem.image = moreTabDeselectedImage
        TabBarItem.selectedImage = moreTabSelectedImage

        
        self.selectedIndex = 2
        
        
    }
    


    


}
