//
//  BaseCollectionViewCell.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/22.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

@objc protocol BaseSwipeLeftCollectionViewDelegate:UICollectionViewDelegate{
    @objc optional func collectionView(_ collectionView:UICollectionView, willEditItemAt indexPath:IndexPath)
}

class BaseSwipeLeftCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    private var panGestureRecognizer:UIPanGestureRecognizer!
    private var tapGestureRecognizer:UITapGestureRecognizer!
    private var isEditing:Bool = false
    var delegate:BaseSwipeLeftCollectionViewDelegate?{
        get{
            
            if let collectionView = self.superview as? UICollectionView{
                
                return collectionView.delegate as? BaseSwipeLeftCollectionViewDelegate
            }else{
                return nil
            }
            
        }
    }
    var editable:Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwipeCellLeft"), object: nil)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
       
        
    }
    
    @objc
    private func handlePanGesture(_ panGestureRecognizer:UIPanGestureRecognizer){
        if editable {
            switch panGestureRecognizer.state {
            case .began:
                let Vx = panGestureRecognizer.velocity(in: panGestureRecognizer.view).x
                let Vy = panGestureRecognizer.velocity(in: panGestureRecognizer.view).y
                let directVector = (-Vx) / sqrt(pow(Vx, 2)+pow(Vy, 2))
                if directVector >= 0.8{
                    willEditCell()
                }else if directVector <= -0.8{
                    handleTap()
                }
            default:
                break
            }
        }
    }
    
    private func willEditCell(){
        if isEditing {
            return
        }
        
        if let collectionView = self.superview as? UICollectionView,let indexPath:IndexPath = collectionView.indexPathForItem(at: self.center){
            
            if let delegate = self.delegate{
                delegate.collectionView?(collectionView, willEditItemAt: indexPath)
            }
        }
        
        isEditing = true
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: -48, y: 0)
        }) { (finish) in
            
        }
    }
    
    @objc
    public func handleTap(){
        if isEditing{
            isEditing = false
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            }) { (finish) in
                
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGestureRecognizer.isEqual(gestureRecognizer){
            
            let Vx = panGestureRecognizer.velocity(in: panGestureRecognizer.view).x
            let Vy = panGestureRecognizer.velocity(in: panGestureRecognizer.view).y
            return abs((-Vx) / sqrt(pow(Vx, 2)+pow(Vy, 2))) < 0.8
        }
        
        if tapGestureRecognizer.isEqual(gestureRecognizer){
            
            return !isEditing
        }
        
        
        
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGestureRecognizer.isEqual(gestureRecognizer){
            let Vx = panGestureRecognizer.velocity(in: panGestureRecognizer.view).x
            let Vy = panGestureRecognizer.velocity(in: panGestureRecognizer.view).y
            return abs((-Vx) / sqrt(pow(Vx, 2)+pow(Vy, 2))) >= 0.8
        }
        
        if tapGestureRecognizer.isEqual(gestureRecognizer){
            return isEditing
        }
        
        return true
    }
}
