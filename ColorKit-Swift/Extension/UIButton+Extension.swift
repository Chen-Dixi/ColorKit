//
//  UIButton+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/18.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

extension UIButton
{
    func antiMultiplyTouch(delay : TimeInterval, closure:@escaping ()->Void)
    {
        self.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // your code here
            self.isUserInteractionEnabled = true
            closure()
        }
//        dispatch_after(
//            dispatch_time(
//                dispatch_time_t(DISPATCH_TIME_NOW),
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), {
//                self.userInteractionEnabled = true
//                closure()
//        })
    }
}
