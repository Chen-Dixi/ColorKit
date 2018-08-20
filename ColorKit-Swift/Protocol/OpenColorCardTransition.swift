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
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        let toview = tovc?.view
//        let fromview = fromvc?.view
//        let containerView = transitionContext.containerView
//        containerView.addSubview(toview!)
//        containerView.bringSubview(toFront: fromview!)
//
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            fromview?.alpha = 0
//            fromview?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            toview?.alpha = 1.0;
//        }){ (finished) in
//            fromview?.transform = CGAffineTransform(scaleX: 1, y: 1)
//            fromview?.alpha = 1
//            transitionContext.completeTransition(true)
//        }

        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toview = tovc?.view
        
        if let tabvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseTabBarController, let navvc = tabvc.selectedViewController as? BaseNavigationController{
            if let containervc = navvc.topViewController as? ColorContainerViewController{
                let containerView = transitionContext.containerView
                
                if let tablevc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorDetailViewController{
                    
                    let cell = tablevc.tableView.cellForRow(at: tablevc.selectedIndex)
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    containerView.addSubview(imageView)
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    }) { (finished) in
                        imageView.isHidden = true
                        transitionContext.completeTransition(true)
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    containerView.addSubview(imageView)
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    }) { (finished) in
                        imageView.isHidden = true
                        transitionContext.completeTransition(true)
                    }
                }
            } else if let containervc = navvc.topViewController as? CollectColorContainerViewController{
                let containerView = transitionContext.containerView
                
                if let tablevc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorDetailViewController{
                    let cell = tablevc.tableView.cellForRow(at: tablevc.selectedIndex)
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    containerView.addSubview(imageView)
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    }) { (finished) in
                        imageView.isHidden = true
                        transitionContext.completeTransition(true)
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    containerView.addSubview(imageView)
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    }) { (finished) in
                        imageView.isHidden = true
                        transitionContext.completeTransition(true)
                    }
                }
            }
        }

    }
    
    
}
