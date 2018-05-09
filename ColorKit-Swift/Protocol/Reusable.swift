//
//  Reusable.swift
//  XiaoDi
//
//  Created by Dixi-Chen on 16/9/7.
//  Copyright © 2016年 Dixi-Chen. All rights reserved.
//

import UIKit


protocol Reusable:class{
    
    static var reuseIdentifier:String{get}
}

extension UITableViewCell:Reusable{
    static var reuseIdentifier:String{
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
