//
//  AppDelegate.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        increateAppRuns()
        
        let appVersion = UserDefaults.standard.string(forKey: "appVersion")
        let infoDictionary = Bundle.main.infoDictionary!
        let currentVersion = infoDictionary["CFBundleShortVersionString"] as! String
        
        transferCoreData(lastVersion: appVersion, currentVersion: currentVersion)
        
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
        recogProjectCode()
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

    lazy var persistentContainer: PersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = PersistentContainer(name: "ColorKit_Swift")
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
    
    lazy var oldPersistentContainer: NSPersistentContainer = {
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
    
    //在App进入前台时是识别口令的好时机
    func recogProjectCode(){
        
        if let code = UIPasteboard.general.string, (code.hasPrefix("{\"colors\":") || code.hasPrefix("{\"projectName\":")) {
            //如果是我们需要的口令，
            
            let managedContext = persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "Project",
                                           in: managedContext)!
            
            let entity2 =
                NSEntityDescription.entity(forEntityName: "Color",
                                           in: managedContext)!
            let alertvc = DetectProjectCodeAlertController {
                //点确定的操作
                
                if let dataFromString = code.data(using: .utf8, allowLossyConversion: false) {
                
                    do {
                        let json = try JSON(data: dataFromString)
                        
                        let colorsJson = json["colors"]
                        let projectName = json["projectName"].string
                        let project = Project(entity: entity, insertInto: managedContext)
                        project.name = projectName
                        project.createdAt = Date()
                        for j in 0..<colorsJson.count{
                            let colorJson = colorsJson[j]
                            let color = FeatureColor(name: colorJson["name"].stringValue, r: CGFloat(colorJson["r"].floatValue), g: CGFloat(colorJson["g"].floatValue), b: CGFloat(colorJson["b"].floatValue))
                            let newColor = Color(entity: entity2, insertInto: managedContext)
        
                            newColor.setValue(color.name, forKey: "name")
                            newColor.setValue(color.r, forKey: "r")
                            newColor.setValue(color.g, forKey: "g")
                            newColor.setValue(color.b, forKey: "b")
                            newColor.setValue(project, forKey: "project")
                            newColor.setValue(false, forKey: "collect")
                            newColor.setValue(Date(), forKey: "createdAt")
                        }
        
                        SafeDispatch.async(forWork: {
                            self.saveContext()
        
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
        
        
                        })
                    }catch let error as NSError{
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
//
            }
            
            if let vc = UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController{
                
                vc.present(alertvc, animated: true, completion: nil)
                UIPasteboard.general.string=""
            }
            //clear code
            
        }
    }
    // vibrate
    lazy var impactFeedbackLightGenerator:UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
    }()
    
    lazy var impactFeedbackMediumGenerator:UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
    }()
    
    lazy var impactFeedbackHeavyGenerator:UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
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
            let projectName = NSLocalizedString("ColorNote", comment: "")
            project.name = projectName
            project.createdAt = Date()
            project.badgeName = "badge_palette"
            project.seq = Int32(UserDefaultsTool.numberOfProjectSeq.value)
            UserDefaultsTool.numberOfProjectSeq.value += 1
            let colorEntity =
                NSEntityDescription.entity(forEntityName: "Color",
                                           in: managedContext)!
            let redColor = Color(entity: colorEntity, insertInto: managedContext)
            
            redColor.setValue(projectName+" 红", forKey: "name")
            redColor.setValue(Int32(192), forKey: "r")
            redColor.setValue(Int32(10), forKey: "g")
            redColor.setValue(Int32(23), forKey: "b")
            redColor.setValue(project, forKey: "project")
            redColor.setValue(true, forKey: "collect")
            redColor.setValue(Date(), forKey: "collectDate")
            redColor.setValue(Date(), forKey: "createdAt")
            let blueColor = Color(entity: colorEntity, insertInto: managedContext)
            
            blueColor.setValue(projectName+" 蓝", forKey: "name")
            blueColor.setValue(Int32(125), forKey: "r")
            blueColor.setValue(Int32(190), forKey: "g")
            blueColor.setValue(Int32(240), forKey: "b")
            blueColor.setValue(project, forKey: "project")
            blueColor.setValue(true, forKey: "collect")
            blueColor.setValue(Date(), forKey: "collectDate")
            
            blueColor.setValue(Date(), forKey: "createdAt")
            saveContext()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlString = url.absoluteString
        let startIndex = urlString.startIndex
        let string = "ColourKit://objectId="
        //"ColourKit://name=\(color)&r=\(red32)&g=\(green32)&b=\(blue32)"
        if urlString.contains(string) {
            let newStartIndex = urlString.index(startIndex, offsetBy: string.count)
            let objectId = urlString[newStartIndex..<urlString.endIndex]
            
            //substring 2 string 2 url
            if let uri = URL(string: String(objectId)){
                if let managedId = persistentContainer.viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri){
                    if let color = persistentContainer.viewContext.object(with: managedId) as? Color{
                        if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController{
                            let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
                            let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
                            vc.tobackgroundColor = CommonUtil.getBackgroundColorFromColorData(color:  color)
                            vc.color = color
                            vc.isAnimateTransitionEnbaled = false
                            tabvc.present(vc, animated: false, completion: nil)
                        
                        }
                    }
                }
            }
            
//            if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController{
//                if let naVc = tabvc.selectedViewController as? BaseNavigationController
//                vc.present(alertvc, animated: false, completion: nil)
//                
//            }
            
        }
        return true
    }
    
    //迁移数据
    func transferCoreData(lastVersion:String?, currentVersion:String){
        if let lastVersionString = lastVersion{//如果安装过app
            let last = lastVersionString.prefix(3)
            let new = currentVersion.prefix(3)
            if last < "1.3" { //如果比这个版本小，就要迁移数据
                // 挨个获取project
                var oldProjects:[Project] = []
                let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
                
                do {
                    oldProjects = try oldPersistentContainer.viewContext.fetch(fetchRequest)
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                let projectEntity = NSEntityDescription.entity(forEntityName: "Project",in: persistentContainer.viewContext)!
                
                let colorEntity = NSEntityDescription.entity(forEntityName: "Color",in: persistentContainer.viewContext)!
                
                
                for project in oldProjects{
                    let newProject = Project(entity: projectEntity, insertInto: persistentContainer.viewContext)
                    newProject.name = project.name
                    newProject.createdAt = project.createdAt
                    newProject.badgeName = project.badgeName
                    newProject.seq = project.seq
                    
                    var oldColors:[Color] = []
                    
                    let predicate = NSPredicate(format: "project = %@", project)
                    let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
                    
                    fetchRequest.predicate = predicate
                    
                    do {
                        oldColors = try oldPersistentContainer.viewContext.fetch(fetchRequest)
                    } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                    }
                    
                    for color in oldColors {
                        let newColor = Color(entity: colorEntity, insertInto: persistentContainer.viewContext)
                        
                        newColor.setValue(color.name, forKey: "name")
                        newColor.setValue(color.r, forKey: "r")
                        newColor.setValue(color.g, forKey: "g")
                        newColor.setValue(color.b, forKey: "b")
                        newColor.setValue(newProject, forKey: "project")
                        newColor.setValue(color.collect, forKey: "collect")
                        newColor.setValue(color.createdAt, forKey: "createdAt")
                        newColor.setValue(color.collectDate, forKey: "collectDate")
                    }
                    
                }
                saveContext()
                
            }
        }
        /*
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Project",
                                       in: managedContext)!
        
        let entity2 =
            NSEntityDescription.entity(forEntityName: "Color",
                                       in: managedContext)!
        SVProgressHUD.show()
        DispatchQueue.global().async {
            let project = Project(entity: entity, insertInto: managedContext)
            project.name = self.project?.name
            project.createdAt = Date()
            for color in self.project?.colors ?? []{
                let newColor = Color(entity: entity2, insertInto: managedContext)
                
                newColor.setValue(color.name, forKey: "name")
                newColor.setValue(color.r, forKey: "r")
                newColor.setValue(color.g, forKey: "g")
                newColor.setValue(color.b, forKey: "b")
                newColor.setValue(project, forKey: "project")
                newColor.setValue(false, forKey: "collect")
                newColor.setValue(Date(), forKey: "createdAt")
                
            }
            SafeDispatch.async(forWork: {
                appDelegate.saveContext()
                SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Download Success", comment: ""))
                delay(time: 1, execute: {
                    SVProgressHUD.dismiss()
                })
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
                //弹出评分框框
                showReview()
            })
        }*/
    }
    
}

