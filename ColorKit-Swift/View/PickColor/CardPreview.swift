//
//  CardPreview.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/10.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class CardPreview: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hexLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.black
        let clearTextColor = getClearTextColor(backgroundColor: UIColor.black)
        titleLabel.textColor = clearTextColor
        hexLabel.textColor = clearTextColor
    }
    
    public func setColor(red red32:Int32,green green32:Int32 ,blue blue32:Int32){
        
        let r :CGFloat = CGFloat(red32)/255.0
        
        let g :CGFloat = CGFloat(green32)/255.0
        let b :CGFloat = CGFloat(blue32)/255.0
        
        let average = (r+g+b)
        hexLabel.textColor = average>labelColorThreshold ? UIColor.black : UIColor.white
        hexLabel.text = CommonUtil.hexColorString(red: red32, green: green32, blue: blue32)
        backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        titleLabel.textColor = average>labelColorThreshold ? UIColor.black : UIColor.white
        
    }
}
