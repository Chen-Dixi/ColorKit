//
//  CommonUtil.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation

class CommonUtil {
    
    private static let hexSet =  ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
    
    static func hexColorString(red r:Int32,green g:Int32 ,blue b:Int32) -> String?{
        
        let rString = hexSet[Int(r/16)] + hexSet[Int(r%16)]
        let gString = hexSet[Int(g/16)] + hexSet[Int(g%16)]
        let bString = hexSet[Int(b/16)] + hexSet[Int(b%16)]
        return "#"+rString+gString+bString
    }
}
