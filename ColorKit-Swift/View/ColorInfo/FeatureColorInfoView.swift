//
//  FeatureColorInfoView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit
import SVProgressHUD
class FeatureColorInfoView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var color:FeatureColor!{
        didSet{
            set(entity: color)
        }
    }
    var style:ColorInfoStyle = .NameAndValue{
        didSet{
            set(style:style)
        }
    }
    
    var titleLabel:UILabel!
    var hexLabel:UILabel!
    var redValueLabel:UILabel!
    var greenValueLabel:UILabel!
    var blueValueLabel:UILabel!
    
    var rgbContainer:UIView!
    private var rgbString = ""
    convenience init(frame:CGRect, entity color:FeatureColor, style: ColorInfoStyle){
        self.init(frame: frame)
        self.color = color
        set(entity: color)
        self.style = style
        set(style:style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        titleLabel = UILabel()
        titleLabel.font = Font_Hiragino.Size_30
        hexLabel = UILabel()
        hexLabel.font = Font_Regular.Size_17
        rgbContainer = UIView()
        redValueLabel = UILabel()
        redValueLabel.font = Font_Regular.Size_17
        greenValueLabel = UILabel()
        greenValueLabel.font = Font_Regular.Size_17
        blueValueLabel = UILabel()
        blueValueLabel.font = Font_Regular.Size_17
        
        
        
        addSubview(titleLabel)
        addSubview(hexLabel)
        addSubview(rgbContainer)
        addSubview(redValueLabel)
        addSubview(greenValueLabel)
        addSubview(blueValueLabel)
        
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(30)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-30)
            make.top.equalTo(self.snp.top).offset(94)
            make.height.equalTo(40)
        }
        hexLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        let hexTap = UITapGestureRecognizer(target: self, action: #selector(pasteHex))
        hexLabel.addGestureRecognizer(hexTap)
        hexLabel.isUserInteractionEnabled = true
        
        redValueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(hexLabel.snp.leading)
            make.top.equalTo(hexLabel.snp.bottom).offset(30)
        }
        greenValueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(redValueLabel.snp.leading)
            make.top.equalTo(redValueLabel.snp.bottom).offset(15)
        }
        blueValueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(greenValueLabel.snp.leading)
            make.top.equalTo(greenValueLabel.snp.bottom).offset(15)
        }
        rgbContainer.snp.makeConstraints { (make) in
            make.top.equalTo(redValueLabel.snp.top)
            make.bottom.equalTo(blueValueLabel.snp.bottom)
            make.leading.equalTo(redValueLabel.snp.leading)
            make.trailing.equalTo(redValueLabel.snp.trailing)
        }
        
        let rgbTap = UITapGestureRecognizer(target: self, action: #selector(pasteRGB))
        rgbContainer.addGestureRecognizer(rgbTap)
        
    }
    
    private func set(entity color:FeatureColor){
        
        let red32 = Int32(color.r)
        let green32 = Int32(color.g)
        let blue32 = Int32(color.b)
        let name = color.name
        
        titleLabel.text = name
        hexLabel.text = CommonUtil.hexColorString(red: red32, green: green32, blue: blue32)
        redValueLabel.text = "R:  \(red32)"
        
        
        greenValueLabel.text = "G:  \(green32)"
        
        
        blueValueLabel.text = "B:  \(blue32)"
        rgbString = "R:\(red32) G:\(green32) B:\(blue32)"
        let r :CGFloat = color.r/255.0
        
        let g :CGFloat = color.g/255.0
        let b :CGFloat = color.b/255.0
        backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        let average = r+g+b
        let textColor = average>labelColorThreshold ? UIColor.black : UIColor.white
        setLabelColor(to: textColor)
    }
    
    private func set(style:ColorInfoStyle){
        titleLabel.isHidden = (1 & style.rawValue) == 0
        hexLabel.isHidden = (2 & style.rawValue) == 0
        redValueLabel.isHidden = (2 & style.rawValue) == 0
        greenValueLabel.isHidden = (2 & style.rawValue) == 0
        blueValueLabel.isHidden = (2 & style.rawValue) == 0
    }
    
    private func setLabelColor(to textColor:UIColor){
        titleLabel.textColor = textColor
        hexLabel.textColor = textColor
        redValueLabel.textColor = textColor
        greenValueLabel.textColor = textColor
        blueValueLabel.textColor = textColor
    }
    
    func updateName(){
        titleLabel.text = color.name
    }
    
    @objc
    private func pasteHex(){
        hexLabel.antiMultiplyTouch(delay: 1.5, closure: {})
        let pas = UIPasteboard.general
        pas.string = hexLabel.text
        hexLabel.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
        noticeTop("已经复制色卡颜色HEX值")
        
    }
    
    @objc
    private func pasteRGB(){
        let pas = UIPasteboard.general
        pas.string = rgbString
        redValueLabel.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
        greenValueLabel.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
        blueValueLabel.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
        
        noticeTop("已经复制色卡颜色RGB值")
        
    }
    

}
