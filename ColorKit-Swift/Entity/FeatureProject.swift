//
//  FeatureProject.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation


class FeatureProject:NSObject{
    
    var name:String
    var colors:[FeatureColor]
    
    init(name:String, colors:[FeatureColor]){
        self.name = name
        self.colors = colors
    }
}


