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
