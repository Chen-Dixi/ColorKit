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
        return UIColor(red:74/255, green:74/255,blue:74/255,alpha:1.00)
    }
}
