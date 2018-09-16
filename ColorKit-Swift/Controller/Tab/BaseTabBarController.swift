//
//  BaseTabBarController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/31.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var centerBtn:UIButton!
    
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
        addCenterButton()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        invokeSelectionFeedback()
    }
    
    private func addCenterButton(){
        centerBtn = UIButton(type: .custom)
        let image = UIImage(named: "icon_add_center")
        centerBtn.frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        centerBtn.setImage(image, for: .normal)
        let hDiff:CGFloat=image!.size.height-tabBar.frame.size.height
        
        if(hDiff < 0){
            centerBtn.center=self.tabBar.center
        }else{
            var center:CGPoint=self.tabBar.center
            center.y=center.y-tabBar.frame.size.height*0.2
            centerBtn.center=center
        }
        view.addSubview(centerBtn)
        
    }

}
