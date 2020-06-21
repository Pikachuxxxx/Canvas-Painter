//
//  MainTabBarVC.swift
//  Canvas Drawing
//
//  Created by phani srikar on 20/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarVC : UITabBarController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor.offWhite
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
}


