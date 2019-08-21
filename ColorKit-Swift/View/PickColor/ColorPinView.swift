//
//  ColorPinView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/14.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorPinView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPanGesture()
    }
    
    override init(image: UIImage?) {
        super.init(image:image)
        setupPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPanGesture(){
        print("setup")
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panGestureRecognizer)
        isUserInteractionEnabled = true
    }

    private var locationOffset:CGPoint = CGPoint.zero
    
    @objc func panGesture(_ panGesture: UIPanGestureRecognizer){
        
        if let superview = superview{
            
            let position = panGesture.location(in: superview)
            let state = panGesture.state
            switch state {
            case .began:
                locationOffset = CGPoint(x: position.x - center.x, y: position.y-center.y)
            case .changed:
                center = CGPoint(x: position.x-locationOffset.x, y: position.y-locationOffset.y)
            default:
                
                locationOffset = CGPoint.zero
            }
        }
    }
}
