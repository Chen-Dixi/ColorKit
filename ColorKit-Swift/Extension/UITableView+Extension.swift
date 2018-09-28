//
//  UITableView+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/10.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

//
//  UITableView+XiaoDi.swift
//  XiaoDi
//
//  Created by Dixi-Chen on 16/9/7.
//  Copyright © 2016年 Dixi-Chen. All rights reserved.
//

import UIKit

extension UITableView{
    func registerClassOf<T: UITableViewCell>(_: T.Type)  {
        
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNibOf<T: UITableViewCell>(_: T.Type) {
        
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderFooterClassOf<T: UITableViewHeaderFooterView>(_: T.Type) {
        
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue HeaderFooter with identifier: \(T.reuseIdentifier)")
        }
        
        return view
    }
    
}

extension UICollectionView{
    func registerNibOf<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T:UICollectionViewCell>(for indexPath:IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}
