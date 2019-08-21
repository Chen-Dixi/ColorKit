//
//  FeaturedLoader.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let ip = "http://120.79.69.249/colorKit/featured/list/"
protocol FeaturedLoaderDelegate: class {
    func featuredLoaderDidUpdate(featuredLoader: FeaturedLoader)
}
class FeaturedLoader{
    weak var delegate:FeaturedLoaderDelegate?
    var entries = [FeatureProject](){
        didSet {
            delegate?.featuredLoaderDidUpdate(featuredLoader: self)
        }
    }
    
    func load(){
//        let colors = [
//            FeatureColor(name: "", r: 252.0, g: 187.0, b: 109),
//            FeatureColor(name: "", r: 216.0, g: 115.0, b: 127.0),
//            FeatureColor(name: "", r: 171.0, g: 108.0, b: 130.0),
//            FeatureColor(name: "", r: 104.0, g: 93.0, b: 121.0),
//            FeatureColor(name: "", r: 71.0, g: 92.0, b: 122.0)
//        ]
//        let project = FeatureProject(name: "好看", colors: colors)
//        self.entries.append(project)
        Alamofire.request(ip, method: .get, parameters: nil).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let arr = JSON(value)
                var projects = [FeatureProject]()
                for i in 0..<arr.count{
                    let proName = arr[i]["projectName"].stringValue
                    var colors = [FeatureColor]()
                    let colorsJson = arr[i]["colors"]
                    for j in 0..<colorsJson.count{
                        let colorJson = colorsJson[j]
                        let color = FeatureColor(name: colorJson["name"].stringValue, r: CGFloat(colorJson["r"].floatValue), g: CGFloat(colorJson["g"].floatValue), b: CGFloat(colorJson["b"].floatValue))
                        colors.append(color)
                    }
                    colors.reverse()
                    let project = FeatureProject(name: proName, colors: colors)
                    projects.append(project)
                    SafeDispatch.async(forWork: {
                        self.entries = projects
                    })
                }
                
            case .failure(let error):
                break
            }
        }
    }
    
    init() {
        
    }
    
}
