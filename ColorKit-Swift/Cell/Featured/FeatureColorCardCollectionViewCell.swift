//
//  FeatureColorCardCollectionViewCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class FeatureColorCardCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var hexLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        
        //layer.shadowRadius = 2
        //layer.masksToBounds = false
        
        layer.shadowOpacity = 0.6
        
    }

    
    func setColor(_ featureColor:FeatureColor){
        let color = UIColor(red: featureColor.r/255.0, green: featureColor.g/255.0, blue: featureColor.b/255.0, alpha: 1.0)
        backgroundColor = color
        let textColor = CommonUtil.getClearTextColor(backgroundColor: color)
        let hextext = CommonUtil.hexColorString(red: featureColor.r, green: featureColor.g, blue: featureColor.b)
        hexLabel.text = hextext
        hexLabel.textColor = textColor
    }
}
