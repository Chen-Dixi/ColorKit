//
//  HexColorTextFieldAndButtonView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/17.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit

class HexColorTextFieldAndButtonView: TextFieldAndButtonView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func isLegalContent() -> Bool {
        if let string = inputTextField.text, string =~ "^#[0-9a-fA-F]{6}$"{
            return true
        }
        return false
    }
    
    override func setupUI() {
        super.setupUI()
        inputTextField.keyboardType = .asciiCapable
    }
    
    override func didClearInpuContent() {
        inputTextField.text = "#"
    }
}
