//
//  ColorCardCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorCardCell : CardCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 12
        
        super.layoutSubviews()
    }
    
    public func setColorInfo(color:Color){
        let red32 = color.value(forKey: "r") as! Int32
        let green32 = color.value(forKey: "g") as! Int32
        let blue32 = color.value(forKey: "b") as! Int32
        let name = color.value(forKey: "name") as? String
        let r :CGFloat = CGFloat(red32)/255.0
        
        let g :CGFloat = CGFloat(green32)/255.0
        let b :CGFloat = CGFloat(blue32)/255.0
        
        let average = (r+g+b)/3.0
        valueLabel.textColor = average>labelColorThreshold ? UIColor.black : UIColor.white
        self.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        valueLabel.text = CommonUtil.hexColorString(red: red32, green: green32, blue: blue32)
        nameLabel.text = name
        nameLabel.textColor = average>labelColorThreshold ? UIColor.black : UIColor.white
        
        redValueLabel.text = "R:  \(red32)"
        redValueLabel.textColor = average > labelColorThreshold ? UIColor.black : UIColor.white
        
        greenValueLabel.text = "G:  \(green32)"
        greenValueLabel.textColor = average > labelColorThreshold ? UIColor.black : UIColor.white
        
        blueValueLabel.text = "B:  \(blue32)"
        blueValueLabel.textColor = average > labelColorThreshold ? UIColor.black : UIColor.white
        
        
    }
}
