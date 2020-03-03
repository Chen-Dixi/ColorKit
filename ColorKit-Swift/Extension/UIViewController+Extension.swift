//
//  UIViewController+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
extension UIViewController{
    
    func invokeSelectionFeedback(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let selectionFeedbackGenerator = appDelegate.selectionFeedbackGenerator
        selectionFeedbackGenerator.selectionChanged()
    }
    
    func invokeImpactFeedbackLight(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackLightGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeImpactFeedbackMedium(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackMediumGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeImpactFeedbackHeavy(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let impactFeedbackGenerator = appDelegate.impactFeedbackHeavyGenerator
        impactFeedbackGenerator.impactOccurred()
    }
    
    func invokeNotificationFeedback(type:UINotificationFeedbackGenerator.FeedbackType ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let notificationFeedbackGenerator = appDelegate.notificationFeedbackGenerator
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    func saveContext (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        appDelegate.saveContext()
    }
    
    func deleteColorData(color:Color){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(color)
        
        appDelegate.saveContext()
        
    }
    
    //MARK: - ColorKit Transaction
    
    func delete(color:Color){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(color)
        
        appDelegate.saveContext()
    }
    
    
}


