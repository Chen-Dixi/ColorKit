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
        let style: UIAlertControllerStyle = (screenWidth > 500) ? .alert : .actionSheet
        self.init(title: title, message: message, preferredStyle: style)
        self.view.tintColor = alertTintColor
    }
    
}


class DeleteProjectAlertController: GreatAlertController {
    convenience init(block : @escaping ()->Void ) {
        self.init(title: "确定要删除此项目吗", message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    }
}

class DeleteColorAlertController: GreatAlertController {
    convenience init(block : @escaping ()->Void ) {
        self.init(title: "确定要删除此色卡吗", message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    }
    convenience init(block : @escaping ()->Void ,cancelBlock: @escaping ()->Void) {
        self.init(title: "确定要删除此色卡吗", message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
            block()
        }))
        self.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            cancelBlock()
        }))
    }
}

class ChooseColorPickerAlertController: GreatAlertController{
    convenience init(rgbBlock : @escaping ()->Void ,imageBlock: @escaping ()->Void) {
        self.init(title: "选择获取色卡的方式", message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "RGB", style: .default, handler: { _ in
            rgbBlock()
        }))
        self.addAction(UIAlertAction(title: "从图片中获取", style: .default, handler: { _ in
            imageBlock()
        }))
        self.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    }
}

class UIImagePickerAlertController:GreatAlertController{
    convenience init(fromLibrary : @escaping ()->Void ,fromCamera: @escaping ()->Void) {
        self.init(title: nil, message: nil)
        // 如何使用
        self.addAction(UIAlertAction(title: "从相册选择", style: .default, handler: { _ in
            fromLibrary()
        }))
        self.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
            fromCamera()
        }))
        self.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    }
}
