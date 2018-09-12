//
//  CloseColorCardTransition.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/16.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class CloseColorCardInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    weak var viewController:UIViewController?
    var interaction:Bool = false
  

    public func addPanGesture(for viewController:UIViewController){
        let screenEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.viewController = viewController
        screenEdgeGesture.edges = UIRectEdge.left
        viewController.view.addGestureRecognizer(screenEdgeGesture)
    }
    
    @objc
    func handlePanGesture(_ panGesture:UIPanGestureRecognizer){
        var percent:CGFloat = 0.0
        let translation = panGesture.translation(in: panGesture.view)
        let length = translation.x
        percent = length/screenWidth

        let state = panGesture.state
        switch state {
        case .began:
            interaction = true
            viewController?.dismiss(animated: true, completion: nil)
        case .changed:
            update(percent)
            
        default:
            interaction = false
            if percent > 0.4{
                finish()
            }else{
                cancel()
            }
            
        }
    }
}
