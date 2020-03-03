//
//  GreatAlertController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/5.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit


class GreatAlertController: UIAlertController {
    
    let alertTintColor = UIColor.NavigationBarTintColor()
    
    convenience init(title: String?, message: String?) {
        let style: UIAlertController.Style = (screenWidth > 500) ? .alert : .actionSheet
        self.init(title: title, message: message, preferredStyle: style)
        self.view.tintColor = alertTintColor
    }
    
}


class DeleteProjectAlertController: GreatAlertController {
    convenience init(block : @escaping ()->Void ) {
        self.init(title: NSLocalizedString("Are you sure you want to delete this project?", comment: ""), message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
    }
}

class DeleteColorAlertController: GreatAlertController {
    convenience init(block : @escaping ()->Void ) {
        self.init(title: NSLocalizedString("Are you sure you want to delete this color?", comment: ""), message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
    }
    convenience init(block : @escaping ()->Void ,cancelBlock: @escaping ()->Void) {
        self.init(title: NSLocalizedString("Are you sure you want to delete this color?", comment: ""), message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in
            cancelBlock()
        }))
    }
}

class ChooseColorPickerAlertController: GreatAlertController{
    convenience init(rgbBlock : @escaping ()->Void ,imageBlock: @escaping ()->Void) {
        self.init(title: NSLocalizedString("Choose how to get a color", comment: ""), message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "RGB", style: .default, handler: { _ in
            rgbBlock()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("From Image", comment: ""), style: .default, handler: { _ in
            imageBlock()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
    }
}

class UIImagePickerAlertController:GreatAlertController{
    convenience init(fromLibrary : @escaping ()->Void ,fromCamera: @escaping ()->Void) {
        self.init(title: nil, message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { _ in
            fromLibrary()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { _ in
            fromCamera()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
    }
}

class DetectProjectCodeAlertController: GreatAlertController{
    convenience init(confirmBlock : @escaping ()->Void ) {
        self.init(title: NSLocalizedString("Code Detected", comment: ""), message: NSLocalizedString("Do you want to import the data?", comment: ""))
        // 如何使用
        
        self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            confirmBlock()
        }))
        self.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
    }
}
