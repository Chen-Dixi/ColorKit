//
//  CreateColorFromImageViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/10.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import KeyboardMan
import CoreData
import SVProgressHUD

private let horizontal_collection_height:CGFloat = 120
private let picker_minimum_line_space:CGFloat = 30

class BatchCreateColorFromImageViewController: PresentBaseViewController {
    
    var scrollview:UIScrollView!
    var project: Project!
    
    var titleInputView:TextFieldAndButtonView!
    var titleBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    var colorPreviewCard : CardPreview!
    var projectBar: ProjectBar!
    var chooseColorImageView:ChooseColorImageView!
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 8
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize.zero
        collectionView.layer.shadowOpacity = 0.8
        
        collectionView.registerNibOf(BatchCreateColorCollectionCell.self)
        return collectionView
    }()
    
    var pushBtn:UIButton!
    //批量添加的东西放在这里面
    var batchCreateHelper:AppendColorHelper = AppendColorHelper()
    
    var keyboardMan = KeyboardMan()
    
    private var r:Int32=0
    private var g:Int32=0
    private var b:Int32=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview = UIScrollView(frame: view.bounds)
        scrollview.backgroundColor = UIColor.CommonViewBackgroundColor()
        scrollview.alwaysBounceVertical = true
        scrollview.canCancelContentTouches = false
        view.addSubview(scrollview)
        collectionView.frame = CGRect(x: screenWidth*0.05, y: 60, width: screenWidth*0.9, height: horizontal_collection_height)
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollview.addSubview(collectionView)
        //        adapter.collectionView = collectionView
        //        adapter.dataSource = self
        batchCreateHelper.delegate = self
        //颜色压栈按钮
        pushBtn = UIButton(type: .custom)
        pushBtn.setImage(UIImage(named: "icon_up"), for: .normal)
        pushBtn.addTarget(self, action: #selector(push_color(_:)), for: .touchUpInside)
        pushBtn.frame = CGRect(x: (screenWidth-45) / 2, y: collectionView.frame.maxY+20, width: 45, height: 45)
        pushBtn.tintColor = UIColor.ColorKitRed()
        scrollview.addSubview(pushBtn)
        
        colorPreviewCard = UINib(nibName: "CardPreview", bundle: nil).instantiate(withOwner: nil, options: nil).last as! CardPreview
        colorPreviewCard.frame = CGRect(x: screenWidth*0.05, y: pushBtn.frame.maxY+20, width: screenWidth*0.9, height: 120)
        
        colorPreviewCard.layer.cornerRadius = 8
        colorPreviewCard.layer.shadowColor = UIColor.lightGray.cgColor
        colorPreviewCard.layer.shadowOffset = CGSize.zero
        
        colorPreviewCard.layer.shadowOpacity = 0.8
        (colorPreviewCard.hexLabel as? BottomLineLabel)?.showUnderline = false
        scrollview.addSubview(colorPreviewCard)
        projectBar = UINib(nibName: "ProjectBar", bundle: nil).instantiate(withOwner: nil, options: nil).last as! ProjectBar
        projectBar.frame = CGRect(x: 0, y: statusBarHeight+(navigationController?.navigationBar.frame.height ?? 64), width: screenWidth, height: 40)
        projectBar.setProject(project)
        view.addSubview(projectBar)
        let projectTap = UITapGestureRecognizer(target: self, action: #selector(showChooseProjectView))
        projectBar.addGestureRecognizer(projectTap)
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNameInputComponent))
        colorPreviewCard.titleLabel.addGestureRecognizer(tap)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler1))
        titleBlackMaskView.addGestureRecognizer(tapGesture1)
        titleInputView = TextFieldAndButtonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45) ) {
            [weak self] (name) in
            if let strongSelf = self{
                strongSelf.colorPreviewCard.titleLabel.text = name
                strongSelf.tapHandler1()// removeFromSubview
                
            }
        }
        
        keyboardMan.animateWhenKeyboardAppear  = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            
            if let strongSelf = self{
                strongSelf.titleInputView.setBottomY(screenHeight-keyboardHeight)
            }
        }
        
        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
            if let strongSelf = self{
                strongSelf.titleInputView.frame.origin.y = screenHeight
            }
        }
        
        chooseColorImageView = ChooseColorImageView(frame: CGRect(x: screenWidth*0.05, y: colorPreviewCard.frame.maxY+picker_minimum_line_space, width: 0.9*screenWidth, height: 200))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapHandler2))
        chooseColorImageView.addGestureRecognizer(tapGesture2)
        
        chooseColorImageView.addShadowEffect(shadowOpacity: 0.8, shadowOffset: CGSize.zero)
        chooseColorImageView.layer.cornerRadius = 8
        chooseColorImageView.rgbCallback = {
            [weak self] r,g,b in
            if let strongSelf = self{
                strongSelf.r = r
                strongSelf.g = g
                strongSelf.b = b
                strongSelf.colorPreviewCard.setColor(red: r, green: g, blue: b)
            }
        }
        chooseColorImageView.colorCallback = {
            [weak self] color in
            if let strongSelf = self{
                strongSelf.colorPreviewCard.backgroundColor = color
            }
        }
        scrollview.addSubview(chooseColorImageView)
        scrollview.contentSize = CGSize(width: 0, height: chooseColorImageView.frame.maxY + 48 )
        
        
        //保存按钮 空的时候disable，有颜色的时候可以按
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - 处理色卡标题
    @objc
    func showNameInputComponent(){
        view.window?.addSubview(titleBlackMaskView)
        
        titleBlackMaskView.addSubview(titleInputView)
        titleInputView.setBottomY(screenHeight)
        titleInputView.displayText = colorPreviewCard.titleLabel.text
        titleInputView.initState()
        UIView.animate(withDuration: 0.3) {
            self.titleBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    @objc
    private func showChooseProjectView(){
        let navi = BaseNavigationController()
        let chooseProjectVC = ChooseProjectViewController { [weak self](project) in
            
            self?.projectBar.setProject(project)
            self?.project = project
        }
        navi.addChildViewController(chooseProjectVC)
        present(navi, animated: true, completion: nil)
    }
    
    @objc
    func tapHandler1(){
        titleInputView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished) in
            self.titleInputView.removeFromSuperview()
            self.titleBlackMaskView.removeFromSuperview()
        }
        
    }
    
    
    
    @objc
    func tapHandler2(){
        //从相机 或者 相册中取得一张图片
        let alertVC = UIImagePickerAlertController(fromLibrary: {
            [weak self] in
            self?.initPhotoPicker()
            }, fromCamera: {
                [weak self] in
                self?.initCameraPicker()
        })
        present(alertVC, animated: true, completion: nil)
    }
    
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
    //拍照
    func initCameraPicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            
            print("不支持拍照")
            
        }
        
    }
    
    @objc
    private func save(_ sender: UIBarButtonItem) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let entity =
//            NSEntityDescription.entity(forEntityName: "Color",
//                                       in: managedContext)!
//
//
//        let newColor = Color(entity: entity, insertInto: managedContext)
//
//        newColor.setValue(colorPreviewCard.titleLabel.text!, forKey: "name")
//        newColor.setValue(r, forKey: "r")
//        newColor.setValue(g, forKey: "g")
//        newColor.setValue(b, forKey: "b")
//        newColor.setValue(project, forKey: "project")
//        newColor.setValue(false, forKey: "collect")
//        newColor.setValue(Date(), forKey: "createdAt")
//
//        saveContext()
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
//        //        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        if batchCreateHelper.count <= 0 {
            return
        }
        
        SVProgressHUD.show()
        
        self.batchCreateHelper.performBatchSave(project) {
            SVProgressHUD.dismiss()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func push_color(_ sender:UIButton){
        let colorItem = MyColor(name: colorPreviewCard.titleLabel.text!, r: r, g: g, b: b)
        sender.antiMultiplyTouch(delay: 0.2){}//disable 一段时间
        
        if batchCreateHelper.colors.count >= 6{
            //不能再添加了
            sender.shake(direction: .horizontal, times: 2, interval: 0.05, delta: 3, completion: nil)
            invokeNotificationFeedback(type: .warning)
            return
        }
        invokeImpactFeedbackMedium()
        batchCreateHelper.append(colorItem)
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: batchCreateHelper.count-1 , section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension BatchCreateColorFromImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image:UIImage!
        if picker.sourceType == .camera{
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        self.dismiss(animated: true, completion: nil)
        chooseColorImageView.setChoosedImage(image: image)
        scrollview.contentSize = CGSize(width: 0, height: chooseColorImageView.frame.maxY+48)
        
    }
}

extension BatchCreateColorFromImageViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AppendColorHelperDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return batchCreateHelper.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BatchCreateColorCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setColor(batchCreateHelper.colors[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
    }
    
    func helperDidUpdate(helper: AppendColorHelper) {
        
    }
    
    func helperIsEmpty(isEmpty: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (horizontal_collection_height-collectionViewMinimumLineSpacing) / screenRatio, height: horizontal_collection_height-collectionViewMinimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        //delete code
        invokeImpactFeedbackLight()
        batchCreateHelper.colors.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

