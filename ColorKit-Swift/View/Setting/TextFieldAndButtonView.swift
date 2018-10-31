//
//  TextFieldAndButtonView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class TextFieldAndButtonView: UIView ,UITextFieldDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var inputTextField:UITextField!
    var confirmButton:UIButton!
    public var displayText:String?
    var buttonConfirmCallback:(String)->Void = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(frame: CGRect, confirm callback:@escaping (String)->Void) {
        self.init(frame: frame)
        buttonConfirmCallback = callback
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        backgroundColor = UIColor.white
        inputTextField = UITextField(frame: CGRect.zero)
        inputTextField.delegate = self
        inputTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        confirmButton = UIButton(frame: CGRect.zero)
        
        
        confirmButton.backgroundColor = UIColor.ColorKitBlue()
        
        confirmButton.setTitle("确认", for: UIControlState.normal)
        
        confirmButton.layer.cornerRadius = 4
        confirmButton.setImage(UIImage.imageWithColor(color: UIColor.lightGray), for: UIControlState.disabled)
        confirmButton.addTarget(self, action: #selector(confirmClick), for: UIControlEvents.touchUpInside)
        addSubview(inputTextField)
        addSubview(confirmButton)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enableConfirmButton),
                                               name: nil,
                                               object: inputTextField)
        updateFrame()
       
    }

    
    deinit{
            NotificationCenter.default.removeObserver(self)
    }

    
    func updateFrame(){
        inputTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(9)
            make.right.equalTo(confirmButton.snp.left).offset(-4)
            make.width.equalTo(bounds.width*0.8)
            make.height.equalTo(confirmButton.snp.height)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-5)
            make.top.equalTo(self.snp.top).offset(5)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !isLegalContent(){
            confirmButton.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
            invokeNotificationFeedback(type: UINotificationFeedbackType.warning)
            
            return false
        }else{
            inputTextField.resignFirstResponder()
            buttonConfirmCallback(inputTextField.text!)
            return true
        }
    }
    
    
    
    @objc
    func enableConfirmButton(){
        if isLegalContent(){
            confirmButton.backgroundColor = UIColor.ColorKitBlue()
            
        }else{
            if let string = inputTextField.text, string == ""{
                didClearInpuContent()
            }
            confirmButton.backgroundColor = UIColor.gray
            
        }
    }
    
    @objc
    func confirmClick(){
        if isLegalContent(){
            inputTextField.resignFirstResponder()
            buttonConfirmCallback(inputTextField.text!)
        }else{
            confirmButton.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
            invokeNotificationFeedback(type: .warning)
        }
        
    }
    
    func isLegalContent() -> Bool{
        if let string = inputTextField.text, string != ""{
            return true
        }
        return false
    }
    
    func didClearInpuContent(){
        
    }
    
    public func initState(){
        inputTextField.text = displayText
        inputTextField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        inputTextField.resignFirstResponder()
        return true
    }
        
}
