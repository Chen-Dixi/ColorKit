//
//  ColorContainerViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class ColorContainerViewController: BaseViewController {

    var project:Project!
    
     var tableVC:ColorDetailViewController!
     var cardVC:ColorCardViewController!
    var cardCollectionVC:ColorCardCollectionViewController!
    private var childSubView:[UIView] = []
    var currenViewIndex:Int = 0
    private var switchvcBtnItem:UIBarButtonItem!
    private var addColorBtnItem :UIBarButtonItem!
    private var settingBtnItem :UIBarButtonItem!
    private var moreBtnItem :UIBarButtonItem!
    private var isListView:Bool = true
    private var switchvcBtnItemImage:[UIImage] = [UIImage(named: "icon_card_view")!,UIImage(named: "icon_list_view")!]
    init(project:Project){
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProject), name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
    }

    override func viewWillLayoutSubviews() {
        updateFrame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI(){
        
        let sb2 = UIStoryboard(name: "ColorCardViewController", bundle: nil)
        cardVC = sb2.instantiateInitialViewController() as! ColorCardViewController
        cardVC.project = project
        
        cardCollectionVC = ColorCardCollectionViewController()
        cardCollectionVC.project = project
        
        view.addSubview(cardVC.view)
        view.addSubview(cardCollectionVC.view)
        
        childSubView.append(cardCollectionVC.view)
        childSubView.append(cardVC.view)
    
        addChild(cardCollectionVC)
        addChild(cardVC)
        
        switchvcBtnItem = UIBarButtonItem(image: UIImage(named: "icon_card_view"), style: .plain, target: self, action: #selector(switchVC))
        switchvcBtnItem.tintColor = UIColor.NavigationBarTintColor()
        
        //项目设置barItem
//        settingBtnItem = UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .plain, target: self, action: #selector(jumpToSetting))
//        settingBtnItem.tintColor = UIColor.NavigationBarTintColor()

        moreBtnItem = UIBarButtonItem(image: UIImage(named: "icon_more"), style: .plain, target: self, action: #selector(moreBtn))
        moreBtnItem.tintColor = UIColor.NavigationBarTintColor()
//
//        addColorBtnItem = UIBarButtonItem(image: UIImage(named: "icon_add_square"), style: .plain, target: self, action: #selector(add))
//        addColorBtnItem.tintColor = UIColor.NavigationBarTintColor()
       
        navigationItem.rightBarButtonItems = [switchvcBtnItem,moreBtnItem]
        //navigationItem.rightBarButtonItems = [switchvcBtnItem,settingBtnItem]
        
        navigationItem.title = project.name
        
    }
    
    private func updateFrame(){
        cardCollectionVC.view.frame = self.view.bounds
        cardVC.view.frame = self.view.bounds
    }
    
    @objc
    func add(){
        let alertVC = ChooseColorPickerAlertController(rgbBlock: {
            [weak self] in
            if let strongSelf = self{
//                let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
//                let vc = sb.instantiateInitialViewController() as! CreateColorViewController
//                vc.pickerType = .create
//                vc.project = strongSelf.project
//                vc.nextSeq = Int32(strongSelf.tableVC.colors.count)
                let vc = NewCreateColorViewController()
                vc.project = strongSelf.project
                let nav = BaseNavigationController()
                nav.addChild(vc)
                strongSelf.present(nav, animated: true, completion: nil)
            }
            
        }, imageBlock: {
            [weak self] in
            if let strongSelf = self{
//                let sb = UIStoryboard(name: "CreateColorFromImageViewController", bundle: nil)
                let vc = CreateColorFromImageViewController()

                vc.project = strongSelf.project
                
                let nav = BaseNavigationController()
                nav.addChild(vc)
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
                strongSelf.present(nav, animated: true, completion: nil)
            }
        })
        present(alertVC, animated: true, completion: nil)
    }
    

    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
                switchVC()
        }
    }
    
    
    
    @objc
    private func moreBtn(){
        let alertVC = GreatAlertController(title: nil, message: nil)
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("Copy Project Code", comment: "") , style: .default, handler: { _ in
            //self.switchVC()
            self.copyCode()
        }))
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("Project Setting", comment: ""), style: .default, handler: { (_) in
            self.jumpToSetting()
        }))
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc
    private func jumpToSetting() {
        let sb = UIStoryboard(name: "ProjectSettingViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! InteractiveTransitionNavigationController
        if let settingVC = vc.topViewController as? ProjectSettingViewController{
            settingVC.project = project
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func jumpToBlendingView(){
        let vc = ColorBlendingViewController()
        present(vc, animated: true, completion: nil)
    }
    @objc
    func switchVC(){
        invokeNotificationFeedback(type: .success)
        currenViewIndex = 1-currenViewIndex
        switchvcBtnItem.image = switchvcBtnItemImage[currenViewIndex]
        view.bringSubviewToFront(childSubView[currenViewIndex])
    }
    
    // 生成项目json口令到剪贴板
    func copyCode(){
        var projectJson = "{\"colors\": [{\"name\": \" \", \"r\": 218.0, \"b\": 0.0, \"g\": 58.0}, {\"name\": \" \", \"r\": 226.0, \"b\": 0.0, \"g\": 119.0}, {\"name\": \" \", \"r\": 255.0, \"b\": 0.0, \"g\": 196.0}, {\"name\": \" \",  \"r\": 102.0, \"b\": 42.0, \"g\": 194.0}], \"projectName\": \"重庆大学D1314\"}"
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        var colors:[Color] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortPredictor]
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        var jsonDict:[String : Any] = ["colors":[],"projectName":project.name]
        var colorArr:[[String:Any]] = []
        for color in colors {
            let red32 = color.value(forKey: "r") as! Int32
            let green32 = color.value(forKey: "g") as! Int32
            let blue32 = color.value(forKey: "b") as! Int32
            let name = color.value(forKey: "name") as? String
            let r :CGFloat = CGFloat(red32)
            
            let g :CGFloat = CGFloat(green32)
            let b :CGFloat = CGFloat(blue32)
            
            let colorinfo:[String:Any] = ["r":r,"g":g,"b":b,"name":name]
            colorArr.append(colorinfo)
        }
        jsonDict["colors"]=colorArr
        projectJson = getJSONStringFromDictionary(dictionary: jsonDict)
        print(projectJson)
        let pas = UIPasteboard.general
        pas.string = projectJson
        
    }
    
    func getJSONStringFromDictionary(dictionary:Dictionary<String, Any>) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    @objc
    func refreshProject(){
        navigationItem.title = project.name
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
