//
//  FeatureTitleCollectionViewCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/31.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class FeatureTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
    }

}
