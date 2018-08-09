//
//  UIView+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/26.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
public enum ShakeDirection: Int
{
    case horizontal
    case vertical
}



extension UIView{
    func snapshotImage()->UIImage?{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    
    func invokeSelectionFeedback(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let selectionFeedbackGenerator = appDelegate.selectionFeedbackGenerator
        selectionFeedbackGenerator.selectionChanged()
    }
    
    func invokeImpactFeedbackLight(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackLightGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeImpactFeedbackMedium(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackMediumGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeImpactFeedbackHeavy(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackHeavyGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeNotificationFeedback(type:UINotificationFeedbackType ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let notificationFeedbackGenerator = appDelegate.notificationFeedbackGenerator
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    func saveContext (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        appDelegate.saveContext()
    }
    
    func setBottomY(_ y:CGFloat){
        var frame = self.frame
        frame.origin.y = y-frame.height
        self.frame = frame
    }
    
    func shake(direction: ShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, delta: CGFloat = 2, completion: (() -> Void)? = nil)
    {
        UIView.animate(withDuration: interval, animations: {
            
            switch direction
            {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (finish) in
            
            if times == 0
            {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (finish) in
                    completion?()
                })
            }
            else
            {
                self.shake(direction: direction, times: times - 1, interval: interval, delta: -delta, completion: completion)
            }
        }
    }
}


