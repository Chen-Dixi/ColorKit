//
//  BadgeBoardView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/2.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class BadgeBoardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var scrollView:UIScrollView!
    var badges:[String]=[]
    var buttonSelectCallback:(String)->Void = {_ in }
    @IBInspectable public var col:Int = 6{
        didSet{
            
        }
    }
    
    fileprivate  lazy var badgeDict:NSDictionary = {
        let path = Bundle.main.path(forResource: "badge_list", ofType: "plist")
        let badge = NSDictionary(contentsOfFile: path!)
        return badge!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(frame: CGRect, select callback:@escaping (String)->Void) {
        self.init(frame: frame)
        buttonSelectCallback = callback
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        scrollView = UIScrollView(frame: bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        backgroundColor = UIColor.white
        badges = badgeDict["badge"] as! [String]
        let contentSize = createBadgeButton(badges)
        scrollView.contentSize = contentSize
        addSubview(scrollView)
    }
    
    private func createBadgeButton(_ badge_Names:[String]) -> CGSize{
        let buttonWidth = self.frame.width / CGFloat(col)
        
        var count = 0;
        while( count < badge_Names.count){
            let button = UIButton(frame: CGRect(x: buttonWidth*CGFloat(count%col), y: buttonWidth*CGFloat(count/col), width: buttonWidth, height: buttonWidth))
            button.setImage(UIImage(named: badge_Names[count]), for: UIControl.State.normal)
            button.tintColor = UIColor.NavigationBarTintColor()
            button.tag = count
            button.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
            scrollView.addSubview(button)
            count += 1
        }
        
        return CGSize(width: 0, height: max(CGFloat((count-1)/(col-1)+1)*buttonWidth, bounds.height ))
    }
    
    @objc
    func btnClick(sender:UIButton?){
        if let tag = sender?.tag{
            buttonSelectCallback(badges[tag])
        }
    }
}
