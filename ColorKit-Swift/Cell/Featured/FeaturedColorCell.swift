//
//  FeaturedColorCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit

class FeaturedColorCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setColor(featureColor:FeatureColor){
        let color = UIColor(red: featureColor.r/255.0, green: featureColor.g/255.0, blue: featureColor.b/255.0, alpha: 1.0)
        let visibleColor = CommonUtil.getClearTextColor(backgroundColor: color)
        backgroundColor = color
        titleLabel.textColor = visibleColor
        subtitleLabel.textColor = visibleColor
        titleLabel.text = featureColor.name
        subtitleLabel.text = featureColor.projectName
    }
}
