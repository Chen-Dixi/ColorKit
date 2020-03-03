//
//  AppenColorHelper.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/11/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol AppendColorHelperDelegate: class {
    func helperDidUpdate(helper: AppendColorHelper)
    func helperIsEmpty(isEmpty:Bool)
}

class AppendColorHelper:NSObject{
    weak var delegate:AppendColorHelperDelegate?
    var colors:[MyColor] = []{
        didSet{
            delegate?.helperIsEmpty(isEmpty: colors.isEmpty)
        }
    }
    
    func append(_ color:MyColor){
        colors.append(color)
    }
    
    var count:Int{
        return colors.count
    }
    
    func performBatchSave(_ project:Project,finished callback:@escaping ()->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Color",
                                       in: managedContext)!
         DispatchQueue.global().async {
            for color in self.colors{
                let newColor = Color(entity: entity, insertInto: managedContext)
                
                newColor.setValue(color.name, forKey: "name")
                newColor.setValue(color.r, forKey: "r")
                newColor.setValue(color.g, forKey: "g")
                newColor.setValue(color.b, forKey: "b")
                newColor.setValue(project, forKey: "project")
                newColor.setValue(false, forKey: "collect")
                newColor.setValue(Date(), forKey: "createdAt")
                
            }
            UserDefaultsTool.recentColorNameInGroup.value = self.colors.last?.name
            SafeDispatch.async(forWork: {
                appDelegate.saveContext()
                callback()
            })
        }
        
    }
}
