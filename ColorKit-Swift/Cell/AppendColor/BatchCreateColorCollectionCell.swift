//
//  BatchCreateColorCollectionCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/11/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import SnapKit

protocol RemoveCellDelegate: class {
    func removeCellDidTapButton(_ cell: BatchCreateColorCollectionCell)
}


class BatchCreateColorCollectionCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    weak var delegate: RemoveCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//            - collectionViewMinimumLineSpacing
//        let width = height / screenRatio
        
        
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 8
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.6
        //不知为何，contentView的范围比cell本身大
        contentView.frame = bounds
    }
    
    func setColor(_ featureColor:MyColor){
        let color = UIColor(red: CGFloat(featureColor.r)/255.0, green: CGFloat(featureColor.g)/255.0, blue: CGFloat(featureColor.b)/255.0, alpha: 1.0)
        backgroundColor = color
        let textColor = CommonUtil.getClearTextColor(backgroundColor: color)
        
        nameLabel.text = String(featureColor.name.prefix(1))
        nameLabel.textColor = textColor
    }
    @IBAction func remove(_ sender: UIButton) {
        if let collectionView = self.superview as? UICollectionView,let indexPath:IndexPath = collectionView.indexPathForItem(at: self.center){
            
            collectionView.delegate?.collectionView?(collectionView, performAction: #selector(remove(_:)), forItemAt: indexPath, withSender: nil)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = deleteBtn.hitTest(deleteBtn.convert(point, from: self), with: event)
        if view == nil {
            view = super.hitTest(point, with: event)
        }
        
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if super.point(inside: point, with: event){
            return true
        }
        
        return !deleteBtn.isHidden && deleteBtn.point(inside: deleteBtn.convert(point, from: self), with: event)
    }
}
