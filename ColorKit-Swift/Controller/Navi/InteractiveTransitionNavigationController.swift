//
//  InteractiveTransitionNavigationController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2019/2/22.
//  Copyright © 2019年 Dixi-Chen. All rights reserved.
//

import UIKit
//present 这个navigation controller，可以通过左滑dismiss
class InteractiveTransitionNavigationController: BaseNavigationController,UIViewControllerTransitioningDelegate {

    var interactiveTransitionController:CloseColorCardInteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        modalPresentationStyle = .custom
        interactiveTransitionController = CloseColorCardInteractiveTransition()
        interactiveTransitionController.addPanGestureAndHookDelegate(for: self)
        // Do any additional setup after loading the view.
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        if gestureRecognizer == interactiveTransitionController.edgeGestureRecognizer {
            if self.viewControllers.count >= 2 || self.visibleViewController != self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SystemCloseTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactiveTransitionController.interaction ? interactiveTransitionController:nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
