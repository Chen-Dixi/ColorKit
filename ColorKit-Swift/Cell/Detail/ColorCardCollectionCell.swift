//
//  ColorCardCollectionCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/21.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorCardCollectionCell: BaseSwipeLeftCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!{
        didSet{
            collectButton.setImage(UIImage(named: "icon_heart"), for: .normal)
            collectButton.setImage(UIImage(named: "icon_heart_solid"), for: .selected)
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!
    
    var color:Color?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 12
        contentView.layer.cornerRadius = 12
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
    
        //layer.shadowRadius = 2
        //layer.masksToBounds = false
        
        layer.shadowOpacity = 0.6
    }

    override func layoutSubviews() {
        
        
        
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
        
        let tempColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        let labelColor = CommonUtil.getClearTextColor(backgroundColor: tempColor)
        contentView.backgroundColor = tempColor
        titleLabel.text = name
        titleLabel.textColor = labelColor
        collectButton.tintColor = labelColor
        collectButton.isSelected = color.collect //收藏按钮
        self.color = color
    }
    
    @IBAction func likeBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        color?.collect = sender.isSelected
        color?.collectDate = Date()
        saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableviewChanged"), object: nil)
    }
    
    @IBAction func deleteColor(_ sender: UIButton) {
        handleTap()
        if let collectionView = self.superview as? UICollectionView,let indexPath:IndexPath = collectionView.indexPathForItem(at: self.center){
            
            collectionView.delegate?.collectionView?(collectionView, performAction: #selector(deleteColor(_:)), forItemAt: indexPath, withSender: nil)
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
