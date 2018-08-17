//
//  OpenColorCardTransition.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/16.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class OpenColorCardTransition: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toview = tovc?.view
        let fromview = fromvc?.view
        let containerView = transitionContext.containerView
        containerView.addSubview(toview!)
        containerView.bringSubview(toFront: fromview!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromview?.alpha = 0
            fromview?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            toview?.alpha = 1.0;
        }){ (finished) in
            fromview?.transform = CGAffineTransform(scaleX: 1, y: 1)
            fromview?.alpha = 1
            transitionContext.completeTransition(true)
        }
        
    }
    
    
}
