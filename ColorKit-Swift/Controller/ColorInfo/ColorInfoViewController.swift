//
//  ColorCardViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/16.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorInfoViewController: UIViewController,UIViewControllerTransitioningDelegate {

    var tobackgroundColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let tobackgroundColor = tobackgroundColor{
            view.backgroundColor = tobackgroundColor
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(motion == UIEventSubtype.motionShake){
            dismiss(animated: true, completion: nil)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OpenColorCardTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OpenColorCardTransition()
    }
    
}
