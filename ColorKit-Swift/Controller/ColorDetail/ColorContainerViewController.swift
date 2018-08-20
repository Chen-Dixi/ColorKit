//
//  ColorContainerViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorContainerViewController: BaseViewController {

    private var project:Project!
    
     var tableVC:ColorDetailViewController!
     var cardVC:ColorCardViewController!
    private var childSubView:[UIView] = []
    var currenViewIndex:Int = 0
    private var switchvcBtnItem:UIBarButtonItem!
    private var addColorBtnItem :UIBarButtonItem!
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
        let sb1 = UIStoryboard(name: "ColorDetailViewController", bundle: nil)
        tableVC = sb1.instantiateInitialViewController() as! ColorDetailViewController
        tableVC.project = project
        let sb2 = UIStoryboard(name: "ColorCardViewController", bundle: nil)
        cardVC = sb2.instantiateInitialViewController() as! ColorCardViewController
        cardVC.project = project
        view.addSubview(cardVC.view)
        view.addSubview(tableVC.view)
        childSubView.append(tableVC.view)
        childSubView.append(cardVC.view)
        addChildViewController(tableVC)
        addChildViewController(cardVC)
        
        switchvcBtnItem = UIBarButtonItem(image: UIImage(named: "icon_card_view"), style: .plain, target: self, action: #selector(switchVC))
        switchvcBtnItem.tintColor = UIColor.NavigationBarTintColor()
        
        addColorBtnItem = UIBarButtonItem(image: UIImage(named: "icon_add_square"), style: .plain, target: self, action: #selector(add))
        addColorBtnItem.tintColor = UIColor.NavigationBarTintColor()
        navigationItem.rightBarButtonItems = [switchvcBtnItem,addColorBtnItem]
        
        
        navigationItem.title = project.name
        
        
    }
    
    private func updateFrame(){
        tableVC.view.frame = self.view.bounds
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
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            
        }, imageBlock: {
            [weak self] in
            if let strongSelf = self{
                let sb = UIStoryboard(name: "CreateColorFromImageViewController", bundle: nil)
                let vc = sb.instantiateInitialViewController() as! CreateColorFromImageViewController

                vc.project = strongSelf.project
                vc.nextSeq = Int32(strongSelf.tableVC.colors.count)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
        present(alertVC, animated: true, completion: nil)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            switchVC()
        }
    }
    
    @objc
    func switchVC(){
        
        invokeSelectionFeedback()
        currenViewIndex = 1-currenViewIndex
        switchvcBtnItem.image = switchvcBtnItemImage[currenViewIndex]
        view.bringSubview(toFront: childSubView[currenViewIndex])
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
