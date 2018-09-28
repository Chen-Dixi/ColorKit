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
        let red = Int(r)
        let green = Int(g)
        let blue = Int(b)
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
    
    
    class func ColorHex(_ color: String) -> (r:Int32,g:Int32,b:Int32)? {
        if color.count <= 0 || color.count != 7 || color == "(null)" || color == "<null>" {
            return nil
        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(color[color.index(color.startIndex, offsetBy: 1)...color.index(color.startIndex, offsetBy: 2)])
        let greenString = String(color[color.index(color.startIndex, offsetBy: 3)...color.index(color.startIndex, offsetBy: 4)])
        let blueString = String(color[color.index(color.startIndex, offsetBy: 5)...color.index(color.startIndex, offsetBy: 6)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        
        return (Int32(red),Int32(green),Int32(blue))
    }
    
    class func getBackgroundColorFromColorData(color:Color) -> UIColor{
        let red32 = color.value(forKey: "r") as! Int32
        let green32 = color.value(forKey: "g") as! Int32
        let blue32 = color.value(forKey: "b") as! Int32
        
        let r :CGFloat = CGFloat(red32)/255.0
        
        let g :CGFloat = CGFloat(green32)/255.0
        let b :CGFloat = CGFloat(blue32)/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

}

