//
//  UIColor+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/9.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

extension UIColor{
    class func CellSeparatorColor() -> UIColor {
        return UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    class func TableViewBackgroundColor() -> UIColor{
        return UIColor(red: 235/255, green: 235/255, blue: 240/255, alpha: 1.00)
    }
    
    class func NavigationBarTintColor() -> UIColor{
        return UIColor(red:81/255, green:82/255,blue:112/255,alpha:1.00)
    }
    
    class func TabBarTintColor() -> UIColor{
        return UIColor(red: 9.0/255.0, green: 10.0/255.0, blue: 2.0/255.0, alpha: 1.0)
    }
    
    class func ColorKitRed() -> UIColor{
        return UIColor(red:192/255, green:10/255,blue:23/255,alpha:1.00)
    }
    
    class func ColorKitGreen() -> UIColor{
        return UIColor(red:45/255, green:176/255,blue:101/255,alpha:1.00)
    }
    
    class func ColorKitBlue() -> UIColor{
        return UIColor(red:125/255, green:190/255,blue:240/255,alpha:1.00)
    }
    
    class func CommonViewBackgroundColor() -> UIColor{
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.00)
    }
    
    
    
}
