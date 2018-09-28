//
//  BaseTabBarController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/31.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var centerBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.tintColor = UIColor.TabBarTintColor()
        tabBar.barTintColor = UIColor.blue
        tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white)
        tabBar.shadowImage = UIImage()
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor;
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        tabBar.layer.shadowOpacity = 0.1;
        
        for item in tabBar.items!{
            item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        }
        addCenterButton()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        invokeSelectionFeedback()
    }
    
    private func addCenterButton(){
        centerBtn = UIButton(type: .custom)
        let image = UIImage(named: "icon_add_center")
        centerBtn.frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        centerBtn.setImage(image, for: .normal)
        let hDiff:CGFloat=image!.size.height-tabBar.frame.size.height
        if hDiff > 0{
            var center:CGPoint=self.tabBar.center
            center.y=tabBar.center.y - (image?.size.height ?? 54)/2
            centerBtn.center=center
            
        }else{
            centerBtn.center = tabBar.center
        }
        
       
        
        view.addSubview(centerBtn)
        
        centerBtn.addTarget(self, action: #selector(centernBtnClick(_:)), for: .touchUpInside)
    }
    
    @objc
    private func centernBtnClick(_ sender:UIButton){
        if let navvc = selectedViewController as? BaseNavigationController{
            if let containervc = navvc.topViewController as? ColorContainerViewController{
                //
                let alertVC = ChooseColorPickerAlertController(rgbBlock: {
                    [weak self] in
                    if let strongSelf = self{
                        //                let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
                        //                let vc = sb.instantiateInitialViewController() as! CreateColorViewController
                        //                vc.pickerType = .create
                        //                vc.project = strongSelf.project
                        //                vc.nextSeq = Int32(strongSelf.tableVC.colors.count)
                        let vc = NewCreateColorViewController()
                        vc.project = containervc.project
                        let nav = BaseNavigationController()
                        nav.addChildViewController(vc)
                        strongSelf.present(nav, animated: true, completion: nil)
                    }
                    
                    }, imageBlock: {
                        [weak self] in
                        if let strongSelf = self{
                            //                let sb = UIStoryboard(name: "CreateColorFromImageViewController", bundle: nil)
                            let vc = CreateColorFromImageViewController()
                            
                            vc.project = containervc.project
                            
                            let nav = BaseNavigationController()
                            nav.addChildViewController(vc)
                            //                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            strongSelf.present(nav, animated: true, completion: nil)
                        }
                })
                present(alertVC, animated: true, completion: nil)
            }else{
                var projects:[Project] = []
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                    return
                }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                
                
                let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
                let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
                fetchRequest.sortDescriptors = [sortPredictor]
                fetchRequest.fetchLimit = 1
                do {
                    projects = try managedContext.fetch(fetchRequest)
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                guard  projects.count > 0 else{
                    SVProgressHUD.showError(withStatus: NSLocalizedString("Create a project first", comment: ""))
                    return
                }
                
                let alertVC = ChooseColorPickerAlertController(rgbBlock: {
                    [weak self] in
                    if let strongSelf = self{
                        //                let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
                        //                let vc = sb.instantiateInitialViewController() as! CreateColorViewController
                        //                vc.pickerType = .create
                        //                vc.project = strongSelf.project
                        //                vc.nextSeq = Int32(strongSelf.tableVC.colors.count)
                        let vc = NewCreateColorViewController()
                        vc.project = projects[0]
                        let nav = BaseNavigationController()
                        nav.addChildViewController(vc)
                        strongSelf.present(nav, animated: true, completion: nil)
                    }

                    }, imageBlock: {
                        [weak self] in
                        if let strongSelf = self{
                            //                let sb = UIStoryboard(name: "CreateColorFromImageViewController", bundle: nil)
                            let vc = CreateColorFromImageViewController()

                            vc.project = projects[0]

                            let nav = BaseNavigationController()
                            nav.addChildViewController(vc)
                            //                strongSelf.navigationController?.pushViewController(vc, animated: true)
                            strongSelf.present(nav, animated: true, completion: nil)
                        }
                })
                present(alertVC, animated: true, completion: nil)
            }
        }
    }

}
