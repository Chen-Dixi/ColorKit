//
//  NibLoadable.swift
//  XiaoDi
//
//  Created by Dixi-Chen on 16/9/7.
//  Copyright © 2016年 Dixi-Chen. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
    static var nibName: String { get }
}

extension UITableViewCell: NibLoadable {
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: NibLoadable {
    
    static var nibName: String {
        return String(describing: self)
    }
}


