//
//  CloseColorCardTransition.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/17.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class CloseColorCardTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromview = fromvc?.view
        let toview = tovc?.view
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toview!)
        
        containerView.bringSubview(toFront: fromview!)
        
        
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)/2 , animations: {
            
            fromview?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }){ (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
