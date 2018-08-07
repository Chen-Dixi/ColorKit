//
//  BaseTabBarController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/31.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.tintColor = UIColor.TabBarTintColor()
        tabBar.barTintColor = UIColor.blue
        tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white)
        tabBar.shadowImage = UIImage()
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor;
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        tabBar.layer.shadowOpacity = 0.1;
        
        for item in tabBar.items!{
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
        
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        invokeSelectionFeedback()
    }
    

}
