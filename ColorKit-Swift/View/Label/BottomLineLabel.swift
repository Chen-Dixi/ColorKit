//
//  BottomLineLabel.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/12/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class BottomLineLabel: UILabel {

    public var showUnderline = true
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if showUnderline {
            let context = UIGraphicsGetCurrentContext()
            let descender = font.descender
            context?.setStrokeColor(textColor.cgColor)
            let l = CGPoint(x: 0, y: self.frame.size.height+descender+1)
            let r = CGPoint(x: frame.width, y: self.frame.size.height+descender+1)
            context?.move(to: l)
            context?.addLine(to: r)
            context?.strokePath()
            context?.closePath()
        }
        super.draw(rect)
    }
 

}
