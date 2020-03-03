//
//  UserDefaultTool.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/24.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

private let numberOfRunsKey = "numberOfRuns"
//Debug review Times
//private let numberOfReviewsKey = "numberOfReviews"

//Release review Times
private let numberOfReviewsKey = "newNumberOfReviews"
private let recentColorNameKey = "recentColorNameKey"
private let numberOfProjectSeqKey = "numberOfProjectSeqKey"

public struct Listener<T>: Hashable {
    
    let name: String
    
    public typealias Action = (T) -> Void
    let action: Action
    
    public var hashValue: Int {
        return name.hashValue
    }
    
    public func hash(into hasher: inout Hasher){
        hasher.combine(name)
    }
}

public func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
    return lhs.name == rhs.name
}
final public class Listenable<T> {
    
    public var value: T {
        didSet {
            setterAction(value)
            
            for listener in listenerSet {
                listener.action(value)
            }
        }
    }
    
    public typealias SetterAction = (T) -> Void
    var setterAction: SetterAction
    
    
    var listenerSet = Set<Listener<T>>()
    
    public func bindListener(_ name: String, action: @escaping Listener<T>.Action) {
        let listener = Listener(name: name, action: action)
        
        listenerSet.insert(listener)
    }
    
    public func bindAndFireListener(_ name: String, action: @escaping Listener<T>.Action) {
        bindListener(name, action: action)
        
        action(value)
    }
    
    public func removeListenerWithName(_ name: String) {
        for listener in listenerSet {
            if listener.name == name {
                listenerSet.remove(listener)
                break
            }
        }
    }
    
    public func removeAllListeners() {
        listenerSet.removeAll(keepingCapacity: false)
    }
    
    public init(_ v: T, setterAction action: @escaping SetterAction) {
        value = v
        setterAction = action
    }
}

final public class UserDefaultsTool{
    static let defaults = UserDefaults.standard
    static let groupDefaults = UserDefaults(suiteName: "group.cdx.ColourKitGroup")
    
    public class func cleanAllUserDefaults() {
        
        do {
            numberOfRuns.removeAllListeners()
            
        }
        
        do { // Manually reset
            numberOfRuns.value=nil
            
            defaults.synchronize()
        }
    }
    public static var numberOfRuns: Listenable<Int?> = {
        let numberOfRuns = defaults.integer(forKey: numberOfRunsKey)
        
        return Listenable<Int?>( numberOfRuns){
            numberOfRuns in
            defaults.set(numberOfRuns, forKey: numberOfRunsKey)
        }
    }()
    
    public static var numberOfProjectSeq: Listenable<Int> = {
        let numberOfProjectSeq = defaults.integer(forKey: numberOfProjectSeqKey)
        
        return Listenable<Int>( numberOfProjectSeq){
            numberOfProjectSeq in
            defaults.set(numberOfProjectSeq, forKey: numberOfProjectSeqKey)
        }
    }()
    
    public static var numberOfReviews: Listenable<Int?> = {
        let numberOfReviews = defaults.integer(forKey: numberOfReviewsKey)
        
        return Listenable<Int?>( numberOfReviews){
            numberOfReviews in
            defaults.set(numberOfReviews, forKey: numberOfReviewsKey)
        }
    }()
    
    public static var recentColorNameInGroup: Listenable<String?> = {
        let recentColorName = groupDefaults?.string(forKey: recentColorNameKey)
        
        return Listenable<String?>( recentColorName){
            recentColorName in
            groupDefaults?.set(recentColorName, forKey: recentColorNameKey)
        }
    }()
    
    public static var recentRedColor: Listenable<Int?> = {
        let recentRedColor = groupDefaults?.integer(forKey: "recentRedColor")
        
        return Listenable<Int?>(recentRedColor){
            recentRedColor in
            groupDefaults?.set(recentRedColor, forKey: "recentRedColor")
        }
    }()
}

func increateAppRuns(){
    if let numberOfRuns = UserDefaultsTool.numberOfRuns.value{
        UserDefaultsTool.numberOfRuns.value = numberOfRuns + 1
    }
}

func increateReviews(){
    if let numerOfReviews = UserDefaultsTool.numberOfReviews.value{
        UserDefaultsTool.numberOfReviews.value = numerOfReviews + 1
    }
}



//弹出3次打分提醒
func showReview(){
    if let numberOfReviews = UserDefaultsTool.numberOfReviews.value{
        if numberOfReviews < 3{
            SKStoreReviewController.requestReview()
            increateReviews()
        }
    }
}



