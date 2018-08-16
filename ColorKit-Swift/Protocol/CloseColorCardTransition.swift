//
//  CloseColorCardTransition.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/16.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class CloseColorCardTransition: UIPercentDrivenInteractiveTransition {
    
    var viewController:UIViewController?
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }

    public func addPanGesture(for viewController:UIViewController){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.viewController = viewController
        viewController.view.addGestureRecognizer(panGesture)

    }
    
    @objc
    func handlePanGesture(_ panGesture:UIPanGestureRecognizer){
        var percent = 0
        
    }
}
