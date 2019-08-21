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


        let tovc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toview = tovc?.view
        
        if let tabvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? BaseTabBarController, let navvc = tabvc.selectedViewController as? BaseNavigationController{
            if let containervc = navvc.topViewController as? ColorContainerViewController{
                let containerView = transitionContext.containerView
                
                if let listvc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorCardCollectionViewController{
                    
                    var cell = listvc.collectionView?.cellForItem(at: listvc.selectedIndex)
                    
                    let image = UIImage.imageWithColor(color: cell?.contentView.backgroundColor ?? UIColor.CommonViewBackgroundColor())
                    let solidImageView = UIImageView(image:image)
                    solidImageView.frame =  cell?.contentView.convert(cell!.contentView.bounds, to: containerView) ?? CGRect(x: 18, y: screenHeight/2, width: screenWidth-36, height: 100)
                    solidImageView.layer.cornerRadius = 12
                    solidImageView.layer.masksToBounds = true
                    containerView.addSubview(solidImageView)
                    
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        solidImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                        
                        
                    }) { (finished) in
                        solidImageView.removeFromSuperview()
                        
                        transitionContext.completeTransition(true)
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? ColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    imageView.layer.cornerRadius = 12
                    imageView.layer.masksToBounds = true
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
                
                if let listvc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorDetailCollectionViewController{
                    var cell = listvc.collectionView?.cellForItem(at: listvc.selectedIndex)
                    
                    let image = UIImage.imageWithColor(color: cell?.contentView.backgroundColor ?? UIColor.CommonViewBackgroundColor())
                    let solidImageView = UIImageView(image:image)
                    solidImageView.frame =  cell?.contentView.convert(cell!.contentView.bounds, to: containerView) ?? CGRect(x: 18, y: screenHeight/2, width: screenWidth-36, height: 100)
                    solidImageView.layer.cornerRadius = 12
                    solidImageView.layer.masksToBounds = true
                    containerView.addSubview(solidImageView)
                    
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        solidImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                        
                        
                    }) { (finished) in
                        solidImageView.removeFromSuperview()
                        
                        transitionContext.completeTransition(true)
                    }
                }else if let cardvc = containervc.childViewControllers[containervc.currenViewIndex] as? CollectColorCardViewController{
                    // 卡片视图的动画
                    let cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    let image = UIImage.imageWithColor(color: cell!.backgroundColor!)
                    let imageView = UIImageView(image:image)
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    imageView.layer.cornerRadius = 12
                    imageView.layer.masksToBounds = true
                    containerView.addSubview(imageView)
                    containerView.insertSubview(toview!, at: 0)
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    }) { (finished) in
                        imageView.isHidden = true
                        transitionContext.completeTransition(true)
                    }
                }
            } else if let featureColorView = navvc.topViewController as? FeaturedColorViewController{
                 let containerView = transitionContext.containerView
                let cell = featureColorView.tableView.cellForRow(at: featureColorView.selectedIndex)
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
