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
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ColorInfoViewController
        let fromview = fromvc.view
        fromview?.alpha = 0
        let containerView = transitionContext.containerView
        let imageView = UIImageView(image: UIImage.imageWithColor(color: fromvc.tobackgroundColor!))
        imageView.frame = fromview!.bounds
        containerView.addSubview(imageView)
        
        if let tabvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BaseTabBarController, let navvc = tabvc.selectedViewController as? BaseNavigationController{
            containerView.insertSubview(tabvc.view, at: 0)
            if let containervc = navvc.topViewController as? ColorContainerViewController{
            
                
                
                if let tablevc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorDetailViewController{
                
    //
    //            let fromview = fromvc?.view
    //            let toview = tovc.view
    //
                    let cell = tablevc.tableView.cellForRow(at: tablevc.selectedIndex)
                
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                        
                    }){ (finished) in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame = cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                        
                    }){ (finished) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                    
                }
            }else if let containervc = navvc.topViewController as? CollectColorContainerViewController{
                if let tablevc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorDetailViewController{
                    
                    //
                    //            let fromview = fromvc?.view
                    //            let toview = tovc.view
                    //
                    let cell = tablevc.tableView.cellForRow(at: tablevc.selectedIndex)
                    
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                        
                    }){ (finished) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame = cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                        
                    }){ (finished) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                    
                }
            }
        }
    }
}
