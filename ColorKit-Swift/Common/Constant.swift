//
//  Constant.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/25.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//


import UIKit
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusBarHeight = UIApplication.shared.statusBarFrame.height
let footerFrame1 = CGRect(x: 0, y: 0, width: screenWidth, height: 48)
let screenRatio = screenHeight / screenWidth
let labelColorThreshold:CGFloat = 2.4

struct Font_Light {
    static let Size_24=UIFont(name: "PingFangSC-Light",size: 24)
    static let Size_20=UIFont(name: "PingFangSC-Light",size: 20)
    static let Size_17=UIFont(name: "PingFangSC-Light",size: 17)
    static let Size_16=UIFont(name: "PingFangSC-Light",size: 16)
    static let Size_18=UIFont(name: "PingFangSC-Light",size: 18)
    static let Size_15=UIFont(name: "PingFangSC-Light",size: 15)
    static let Size_13=UIFont(name: "PingFangSC-Light",size: 13)
    static let Size_12=UIFont(name: "PingFangSC-Light",size: 12)
    static let Size_11=UIFont(name: "PingFangSC-Light", size: 11)
}
struct Font_Regular {
    static let Size_30=UIFont(name:"PingFangSC-Regular",size: 30)
    static let Size_24=UIFont(name:"PingFangSC-Regular",size: 24)
    static let Size_17=UIFont(name:"PingFangSC-Regular",size: 17)
    static let Size_15=UIFont(name:"PingFangSC-Regular",size: 15)
    static let Size_11=UIFont(name:"PingFangSC-Regular",size: 11)
    static let Size_12=UIFont(name:"PingFangSC-Regular",size: 12)
}

struct Font_Hiragino{
    static let Size_30=UIFont(name:"HiraMinProN-W6",size: 30)
}
