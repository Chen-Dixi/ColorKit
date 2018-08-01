//
//  UIImage+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

extension UIImage{
    class func imageWithColor(color:UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
