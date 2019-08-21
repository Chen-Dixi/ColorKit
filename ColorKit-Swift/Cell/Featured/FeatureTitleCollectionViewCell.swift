//
//  FeatureTitleCollectionViewCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/31.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

protocol FunctionalCellDelegate:class {
    func functionButtonDidTap(_ cell:UICollectionViewCell)
}

class FeatureTitleCollectionViewCell: UICollectionViewCell {

    weak var delegate:FunctionalCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
    }

    
    @IBAction func download(_ sender: UIButton) {
        sender.antiMultiplyTouch(delay: 0.3) {}
        delegate?.functionButtonDidTap(self)
    }
}
