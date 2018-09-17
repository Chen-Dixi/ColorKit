//
//  FeatureColor.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import Foundation
import UIKit
class FeatureColor{
    public var r:CGFloat=0
    public var g:CGFloat=0
    public var b:CGFloat=0
    public var name:String=""
    public var projectName:String=""
    
    init(){
        
    }
    
    init(name:String, r:CGFloat, g:CGFloat, b:CGFloat) {
        self.name = name
        self.r = r
        self.g = g
        self.b = b
    }
    
}
