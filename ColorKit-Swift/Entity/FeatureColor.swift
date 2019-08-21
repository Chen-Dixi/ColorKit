//
//  FeatureColor.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import Foundation
import UIKit
class MyColor:NSObject{
    public var r:Int32=0
    public var g:Int32=0
    public var b:Int32=0
    public var name:String=""
    public var projectName:String=""
    
    
    
    init(name:String, r:Int32, g:Int32, b:Int32) {
        self.name = name
        self.r = r
        self.g = g
        self.b = b
    }
    
}
class FeatureColor: NSObject{
    public var r:CGFloat=0
    public var g:CGFloat=0
    public var b:CGFloat=0
    public var name:String=""
    public var projectName:String=""
    
    
    
    init(name:String, r:CGFloat, g:CGFloat, b:CGFloat) {
        self.name = name
        self.r = r
        self.g = g
        self.b = b
    }
}


