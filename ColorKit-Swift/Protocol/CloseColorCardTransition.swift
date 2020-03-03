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
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        containerView.addSubview(imageView)
        
        if let tabvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BaseTabBarController, let navvc = tabvc.selectedViewController as? BaseNavigationController{
            containerView.insertSubview(tabvc.view, at: 0)
            if let containervc = navvc.topViewController as? ColorContainerViewController{
            
                
                
                if let listvc = containervc.children[containervc.currenViewIndex] as? ColorCardCollectionViewController{
                
    //
    //            let fromview = fromvc?.view
    //            let toview = tovc.view
    //
                    var cell = listvc.collectionView?.cellForItem(at: listvc.selectedIndex)
                    if cell == nil {
                        //            self.collectionView.reloadData()
                        listvc.collectionView?.layoutIfNeeded()
                        cell = listvc.collectionView?.cellForItem(at:listvc.selectedIndex)
                        
                        listvc.collectionView?.selectItem(at: listvc.selectedIndex, animated: false, scrollPosition: .centeredVertically)
                    }
                    
                   
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame =  cell?.contentView.convert(cell!.contentView.bounds, to: containerView) ?? CGRect(x: 18, y: screenHeight/2, width: screenWidth-36, height: 100)
                        
                    }){ (finished) in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                }else if let cardvc = containervc.children[containervc.currenViewIndex] as? ColorCardViewController{
                    // 卡片视图的动画
                    var cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at: cardvc.selectedIndex)
                    if cell == nil {
                        //            self.collectionView.reloadData()
                        cardvc.cardSwiper.verticalCardSwiperView.layoutIfNeeded()
                        cell = cardvc.cardSwiper.verticalCardSwiperView.cellForItem(at:cardvc.selectedIndex)
                        
                        cardvc.cardSwiper.verticalCardSwiperView.selectItem(at: cardvc.selectedIndex, animated: false, scrollPosition: .centeredVertically)
                    }
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame = cell?.contentView.convert(cell!.contentView.bounds, to: containerView) ?? CGRect(x: screenWidth/2, y: screenHeight/2, width: 0, height: 0)
                        
                    }){ (finished) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                    
                }
            }else if let containervc = navvc.topViewController as? CollectColorContainerViewController{
                if let listvc = containervc.children[containervc.currenViewIndex] as? CollectColorDetailCollectionViewController{
                   
                    var cell = listvc.collectionView?.cellForItem(at: listvc.selectedIndex)
                    if cell == nil {
                        //            self.collectionView.reloadData()
                        listvc.collectionView?.layoutIfNeeded()
                        cell = listvc.collectionView?.cellForItem(at:listvc.selectedIndex)
                        
                        listvc.collectionView?.selectItem(at: listvc.selectedIndex, animated: false, scrollPosition: .centeredVertically)
                    }
                    
                    
                    UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                        
                        imageView.frame =  cell?.contentView.convert(cell!.contentView.bounds, to: containerView) ?? CGRect(x: 18, y: screenHeight/2, width: screenWidth-36, height: 100)
                        
                    }){ (finished) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        if transitionContext.transitionWasCancelled{
                            fromview?.alpha = 1
                            imageView.removeFromSuperview()
                        }
                    }
                }else if let cardvc = containervc.children[containervc.currenViewIndex] as? CollectColorCardViewController{
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

class CloseFeatureColorCardTransition:CloseColorCardTransition{
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! FeatureColorInfoViewController
        let fromview = fromvc.view
        fromview?.alpha = 0
        let containerView = transitionContext.containerView
        let imageView = UIImageView(image: UIImage.imageWithColor(color: fromvc.tobackgroundColor!))
        imageView.frame = fromview!.bounds
        containerView.addSubview(imageView)
        
        if let tabvc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? BaseTabBarController, let navvc = tabvc.selectedViewController as? BaseNavigationController{
            containerView.insertSubview(tabvc.view, at: 0)
            if let featurevc = navvc.topViewController as? FeaturedColorViewController{
                let cell = featurevc.tableView.cellForRow(at: featurevc.selectedIndex)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext) , animations: {
                    
                    imageView.frame =  cell!.contentView.convert(cell!.contentView.bounds, to: containerView)
                    
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
