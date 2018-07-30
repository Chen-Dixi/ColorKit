//
//  CreateColorViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/29.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import SnapKit

class CreateColorViewController: BaseViewController {

    var colorBoardView:UIView!
    var redSliderView:CapsuleSliderView!
    var greenSliderView:CapsuleSliderView!
    var blueSliderView:CapsuleSliderView!
    private var r:CGFloat=0
    private var g:CGFloat=0
    private var b:CGFloat=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        colorBoardView = UIView(frame: CGRect.zero)
        redSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitRed(), slidingCallback: {[weak self] (redValue) in
            if let strongSelf = self{
                strongSelf.r = CGFloat(redValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
            
        })
        greenSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitGreen(), slidingCallback: {[weak self] (greenValue) in
            if let strongSelf = self{
                strongSelf.g = CGFloat(greenValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
            
        })
        blueSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitBlue(), slidingCallback: {[weak self] (blueValue) in
            if let strongSelf = self{
                strongSelf.b = CGFloat(blueValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
        })
        view.addSubview(colorBoardView)
        view.addSubview(redSliderView)
        view.addSubview(greenSliderView)
        view.addSubview(blueSliderView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        updateFrame()
    }

    func updateFrame(){
        colorBoardView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(60)
            make.width.equalTo(colorBoardView.snp.height)
        }
        greenSliderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(colorBoardView.snp.centerX)
            make.top.equalTo(colorBoardView.snp.bottom).offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(greenSliderView.snp.height).multipliedBy(0.4)
        }
        redSliderView.snp.makeConstraints { (make) in
            make.centerY.equalTo(greenSliderView.snp.centerY)
            make.left.equalTo(colorBoardView.snp.left)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(redSliderView.snp.height).multipliedBy(0.4)

        }
        blueSliderView.snp.makeConstraints { (make) in
            make.centerY.equalTo(greenSliderView.snp.centerY)
            make.right.equalTo(colorBoardView.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(blueSliderView.snp.height).multipliedBy(0.4)

        }
    }
    

}
