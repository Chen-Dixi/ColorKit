//
//  FeatureColorCardCollectionViewCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class FeatureColorCardCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        layer.cornerRadius = 12
        contentView.layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        
        //layer.shadowRadius = 2
        //layer.masksToBounds = false
        
        layer.shadowOpacity = 0.6
    }
}
