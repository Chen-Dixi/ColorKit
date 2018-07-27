//
//  UIView+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/26.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

extension UIView{
    func snapshotImage()->UIImage?{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}
