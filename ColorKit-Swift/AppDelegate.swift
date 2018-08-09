//
//  AppDelegate.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let appVersion = UserDefaults.standard.string(forKey: "appVersion")
        let infoDictionary = Bundle.main.infoDictionary!
        let currentVersion = infoDictionary["CFBundleShortVersionString"] as! String
        
        if appVersion == nil || appVersion != currentVersion{
            //版本有更新
            UserDefaults.standard.set(currentVersion, forKey: "appVersion")
            //版本更新，色卡又是空的就创建初识项目和颜色
            createThemeData()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ColorKit_Swift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // vibrate
    lazy var impactFeedbackLightGenerator:UIImpactFeedbackGenerator = {
      return UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.light)
    }()
    
    lazy var impactFeedbackMediumGenerator:UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.medium)
    }()
    
    lazy var impactFeedbackHeavyGenerator:UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy)
    }()

    lazy var selectionFeedbackGenerator:UISelectionFeedbackGenerator = {
        return  UISelectionFeedbackGenerator()
    }()
    
    lazy var notificationFeedbackGenerator:UINotificationFeedbackGenerator = {
       return UINotificationFeedbackGenerator()
    }()
    
    func createThemeData(){
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        var projects:[Project] = []
        do {
            projects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if projects.isEmpty{
            let entity =
                NSEntityDescription.entity(forEntityName: "Project",
                                           in: managedContext)!
            let project = Project(entity: entity, insertInto: managedContext)
            project.name = "小颜"
            project.seq = Int32(0)
            project.badgeName = "badge_palette"
            saveContext()
            let colorEntity =
                NSEntityDescription.entity(forEntityName: "Color",
                                           in: managedContext)!
            let redColor = Color(entity: colorEntity, insertInto: managedContext)
            
            redColor.setValue("小颜红", forKey: "name")
            redColor.setValue(Int32(192), forKey: "r")
            redColor.setValue(Int32(10), forKey: "g")
            redColor.setValue(Int32(23), forKey: "b")
            redColor.setValue(project, forKey: "project")
            redColor.setValue(false, forKey: "collect")
            redColor.setValue(0, forKey: "seq")
            let blueColor = Color(entity: colorEntity, insertInto: managedContext)
            
            blueColor.setValue("小颜蓝", forKey: "name")
            blueColor.setValue(Int32(125), forKey: "r")
            blueColor.setValue(Int32(190), forKey: "g")
            blueColor.setValue(Int32(240), forKey: "b")
            blueColor.setValue(project, forKey: "project")
            blueColor.setValue(false, forKey: "collect")
            blueColor.setValue(1, forKey: "seq")
            saveContext()
        }
    }
    
}

