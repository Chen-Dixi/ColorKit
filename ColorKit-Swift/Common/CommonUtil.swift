//
//  CommonUtil.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation
import UIKit
class CommonUtil {
    
    private static let hexSet =  ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
    
    static func hexColorString(red r:Int32,green g:Int32 ,blue b:Int32) -> String?{
        
        let rString = hexSet[Int(r/16)] + hexSet[Int(r%16)]
        let gString = hexSet[Int(g/16)] + hexSet[Int(g%16)]
        let bString = hexSet[Int(b/16)] + hexSet[Int(b%16)]
        return "#"+rString+gString+bString
    }
    
    static func hexColorString(red r:CGFloat,green g:CGFloat ,blue b:CGFloat) -> String?{
        let red = Int(r*255)
        let green = Int(g*255)
        let blue = Int(b*255)
        let rString = hexSet[red/16] + hexSet[red%16]
        let gString = hexSet[green/16] + hexSet[green%1]
        let bString = hexSet[blue/16] + hexSet[blue%16]
        return "#"+rString+gString+bString
    }
    
    static func getClearTextColor(backgroundColor:UIColor) -> UIColor{
        var r:CGFloat = 0;
        var g:CGFloat = 0;
        var b:CGFloat = 0;
        var alpha:CGFloat = 0;
        backgroundColor.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        let mean = r+g+b
        
        return mean > labelColorThreshold ? UIColor.black : UIColor.white
    }
    
    
}
