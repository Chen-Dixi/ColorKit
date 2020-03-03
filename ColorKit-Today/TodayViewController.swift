//
//  TodayViewController.swift
//  ColorKit-Today
//
//  Created by Dixi-Chen on 2019/9/26.
//  Copyright © 2019 Dixi-Chen. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit
import CoreData



class TodayViewController: UIViewController, NCWidgetProviding {
    
    var titleLabel:UILabel!
    var hexLabel:UILabel!
    
    var longPress: UILongPressGestureRecognizer!
    var tap: UITapGestureRecognizer!
    var currentColorIndex:Int = 0
    
    fileprivate var colors:[Color] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //两个label
        titleLabel = UILabel()
        hexLabel = UILabel()
        
        
        hexLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.white
        hexLabel.text = "#6DB5DD"
        titleLabel.text = "天"
        hexLabel.font = Font_Regular.Size_17
        titleLabel.font = Font_FandolSong_Bold.Size_30
        self.view.addSubview(titleLabel)
        self.view.addSubview(hexLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.centerY).offset(-5)
            make.left.equalTo(view.snp.left).offset(26)
        }
        hexLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        loadData()
        
        //长按跳转到APP上
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(_:)))
        tap = UITapGestureRecognizer(target:self, action: #selector(tapGestureHandler(_:)))
        self.view.addGestureRecognizer(longPress)
        self.view.addGestureRecognizer(tap)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        // 看文档应该是在这里找数据展示
        loadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func loadData(){
        
//        let defaults = UserDefaults(suiteName: "group.cdx.ColourKitGroup")
//        self.titleLabel.text = defaults?.string(forKey: "recentColorNameKey")
        
        //从CoreData加载数据
        DispatchQueue.global().async {
            
            //加载所有color
            let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
            let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: false) //最新到最旧
            fetchRequest.sortDescriptors = [sortPredictor]
            do {
                self.colors = try self.persistentContainer.viewContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            SafeDispatch.async(forWork: {
                self.goToStart()
            })
        }
    }
    
    func next(){
        currentColorIndex = currentColorIndex % colors.count
        let color = colors[currentColorIndex]
        set(entity: color)
        
        currentColorIndex = (currentColorIndex + 1) % colors.count
    }
    
    //展示第一个颜色
    func goToStart(){
        currentColorIndex = 0
        next()
    }
    
    private func set(entity color:Color){
        
        let red32 = color.value(forKey: "r") as! Int32
        let green32 = color.value(forKey: "g") as! Int32
        let blue32 = color.value(forKey: "b") as! Int32
        let name = color.value(forKey: "name") as? String
        
        titleLabel.text = name
        hexLabel.text = CommonUtil.hexColorString(red: red32, green: green32, blue: blue32)
        
        
        let r :CGFloat = CGFloat(red32)/255.0
        let g :CGFloat = CGFloat(green32)/255.0
        let b :CGFloat = CGFloat(blue32)/255.0
        
        let average = r+g+b
        let textColor = average > 2.3 ? UIColor.black : UIColor.white
        UIView.animate(withDuration: 0.618, animations: {
            self.titleLabel.textColor=textColor
            self.hexLabel.textColor = textColor
            self.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }) { (finished) in
            
            
        }
        
        
    }
    
    //点按换色卡，长按打开App，
    @objc
    func longPressGestureHandler(_ gesture:UILongPressGestureRecognizer){
        let color = colors[(currentColorIndex+colors.count-1) % colors.count]
        let objectId = color.objectID.uriRepresentation()
        
        
        
        
        //url必须符合规范，n
        let strLoc = "ColourKit://objectId=\(objectId)" //name不能够放进去，有空格等无关字符，怎么办，还是用seq,所以还是传project
        
        if let url = URL(string: strLoc){
            extensionContext?.open(url, completionHandler: { (_) in
                
            })
        }
        
    }
    
    @objc
    func tapGestureHandler(_ gesture:UITapGestureRecognizer){
        //换颜色
        next()
    }

}
