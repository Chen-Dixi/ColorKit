//
//  ColorTitleCollectionCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/21.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorTitleCollectionCell: BaseSwipeLeftCollectionViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    private var originCenter :CGPoint = CGPoint.zero
    
    
    
    
    override func layoutSubviews() {
        
    
        
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwipeCellLeft"), object: nil)
        
        
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        //layer.shadowRadius = 2
        //layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        
        //layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
    }

    @IBAction func deleteItem(_ sender: UIButton) {
        handleTap()
        if let collectionView = self.superview as? UICollectionView,let indexPath:IndexPath = collectionView.indexPathForItem(at: self.center){
            
            collectionView.delegate?.collectionView?(collectionView, performAction: #selector(deleteItem(_:)), forItemAt: indexPath, withSender: nil)
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
//(-translate.x) / sqrt(pow(translate.x, 2)+pow(translate.y, 2)) > 0.5

