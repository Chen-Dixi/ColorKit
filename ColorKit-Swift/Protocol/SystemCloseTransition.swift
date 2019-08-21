//
//  SystemCloseTransition.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/20.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class SystemCloseTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containerView = transitionContext.containerView
        containerView.insertSubview((tovc?.view)!, at: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromvc?.view.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
        
        
    
}
