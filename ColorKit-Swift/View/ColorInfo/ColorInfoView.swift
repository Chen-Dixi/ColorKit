//
//  ColorInfoView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/18.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

enum ColorInfoStyle:Int{
    case NameAndValue = 3
    case ValueOnly = 2
    case NameOnly = 1
    case Clear = 0
    
}
class ColorInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var color:Color!{
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
    
    convenience init(frame:CGRect, entity color:Color, style: ColorInfoStyle){
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
        
        redValueLabel = UILabel()
        redValueLabel.font = Font_Regular.Size_17
        greenValueLabel = UILabel()
        greenValueLabel.font = Font_Regular.Size_17
        blueValueLabel = UILabel()
        blueValueLabel.font = Font_Regular.Size_17
        
        addSubview(titleLabel)
        addSubview(hexLabel)
        addSubview(redValueLabel)
        addSubview(greenValueLabel)
        addSubview(blueValueLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(30)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-30)
            make.top.equalTo(self.snp.top).offset(94)
        }
        hexLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
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
    }
    
    private func set(entity color:Color){
        
        let red32 = color.value(forKey: "r") as! Int32
        let green32 = color.value(forKey: "g") as! Int32
        let blue32 = color.value(forKey: "b") as! Int32
        let name = color.value(forKey: "name") as? String
        
        titleLabel.text = name
        hexLabel.text = CommonUtil.hexColorString(red: red32, green: green32, blue: blue32)
        redValueLabel.text = "R:  \(red32)"
        
        
        greenValueLabel.text = "G:  \(green32)"
        
        
        blueValueLabel.text = "B:  \(blue32)"
        
        let r :CGFloat = CGFloat(red32)/255.0
        
        let g :CGFloat = CGFloat(green32)/255.0
        let b :CGFloat = CGFloat(blue32)/255.0
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

}
