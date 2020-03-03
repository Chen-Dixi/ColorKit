//
//  BatchNewCreateColorViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/11/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import KeyboardMan

import CoreData
import AudioToolbox
import IGListKit
import SVProgressHUD

private let horizontal_collection_height:CGFloat = 120
private let slider_minimum_line_space:CGFloat = 30
class BatchNewCreateColorViewController: PresentBaseViewController {

    lazy var adapter: ListAdapter = {
        let adapter =  ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        //adapter.dataSource = self
        return adapter
    }()
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
    
    var scrollview:UIScrollView!
    var project: Project!
    var titleInputView:TextFieldAndButtonView!
    var hexInputView:HexColorTextFieldAndButtonView!
    var titleBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    var hexColorBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    var colorPreviewCard : CardPreview!
    var projectBar: ProjectBar!
    var keyboardMan = KeyboardMan()
    
    var redSlider:Slider!
    var greenSlider:Slider!
    var blueSlider:Slider!
    var soundId:SystemSoundID=0
    var isPlaying = false
    private var r:Int32=0
    private var g:Int32=0
    private var b:Int32=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview = UIScrollView(frame: view.bounds)
        scrollview.backgroundColor = UIColor.CommonViewBackgroundColor()
        scrollview.alwaysBounceVertical = true
        scrollview.showsVerticalScrollIndicator = false
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
        colorPreviewCard.frame = CGRect(x: screenWidth*0.05, y: pushBtn.frame.maxY+20, width: screenWidth*0.9, height: 100)
        
        colorPreviewCard.layer.cornerRadius = 8
        colorPreviewCard.layer.shadowColor = UIColor.lightGray.cgColor
        colorPreviewCard.layer.shadowOffset = CGSize.zero
        colorPreviewCard.layer.shadowOpacity = 0.8
        
        
        scrollview.addSubview(colorPreviewCard)
        projectBar = UINib(nibName: "ProjectBar", bundle: nil).instantiate(withOwner: nil, options: nil).last as! ProjectBar
        projectBar.frame = CGRect(x: 0, y: statusBarHeight+(navigationController?.navigationBar.frame.height ?? 0   ), width: screenWidth, height: 40)
        projectBar.setProject(project)
        view.addSubview(projectBar)
        let projectTap = UITapGestureRecognizer(target: self, action: #selector(showChooseProjectView))
        projectBar.addGestureRecognizer(projectTap)
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNameInputComponent))
        colorPreviewCard.titleLabel.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showHexInputComponent))
        colorPreviewCard.hexLabel.addGestureRecognizer(tap2)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler1))
        titleBlackMaskView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapHandler2))
        hexColorBlackMaskView.addGestureRecognizer(tapGesture2)
        titleInputView = TextFieldAndButtonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45) ) {
            [weak self] (name) in
            if let strongSelf = self{
                strongSelf.colorPreviewCard.titleLabel.text = name
                strongSelf.tapHandler1()// removeFromSubview
                
            }
        }
        hexInputView = HexColorTextFieldAndButtonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45) ) {
            [weak self] (hex) in
            if let strongSelf = self{
                
                let (r,g,b) = CommonUtil.ColorHex(hex) ?? (0,0,0)
                (strongSelf.r,strongSelf.g,strongSelf.b) = (r,g,b)
                strongSelf.redSlider.fraction = CGFloat(r)/255
                strongSelf.greenSlider.fraction = CGFloat(g)/255
                strongSelf.blueSlider.fraction = CGFloat(b)/255
                strongSelf.colorPreviewCard.setColor(red: r, green: g, blue: b)
                strongSelf.tapHandler2()// removeFromSubview
                
            }
        }
        keyboardMan.animateWhenKeyboardAppear  = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            
            if let strongSelf = self{
                strongSelf.titleInputView.setBottomY(screenHeight-keyboardHeight)
                strongSelf.hexInputView.setBottomY(screenHeight-keyboardHeight)
            }
        }
        
        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
            if let strongSelf = self{
                strongSelf.titleInputView.frame.origin.y = screenHeight
                strongSelf.hexInputView.frame.origin.y = screenHeight
            }
        }
        
        redSlider = Slider()
        redSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (Int32(fraction * 255)) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        redSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        redSlider.setMaximumLabelAttributedText(NSAttributedString(string: "255", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        redSlider.fraction = 0
        redSlider.shadowOffset = CGSize(width: 0, height: 10)
        redSlider.shadowBlur = 5
        redSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        redSlider.contentViewColor = UIColor.ColorKitRed()
        redSlider.valueViewColor = .white
        redSlider.isAnimationEnabled = false
        redSlider.addTarget(self, action: #selector(redSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(redSlider)
        redSlider.frame = CGRect(x: screenWidth*0.05, y: colorPreviewCard.frame.maxY+slider_minimum_line_space, width: 0.9*screenWidth, height: 44)
        
        greenSlider = Slider()
        greenSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (Int32(fraction * 255)) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        greenSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        greenSlider.setMaximumLabelAttributedText(NSAttributedString(string: "255", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        greenSlider.fraction = 0
        greenSlider.shadowOffset = CGSize(width: 0, height: 10)
        greenSlider.shadowBlur = 5
        greenSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        greenSlider.contentViewColor = UIColor.ColorKitGreen()
        greenSlider.valueViewColor = .white
        greenSlider.isAnimationEnabled = false
        greenSlider.addTarget(self, action: #selector(greenSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(greenSlider)
        greenSlider.frame = CGRect(x: screenWidth*0.05, y: redSlider.frame.maxY+slider_minimum_line_space, width: 0.9*screenWidth, height: 44)
        
        blueSlider = Slider()
        blueSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (Int32(fraction * 255)) as NSNumber) ?? ""
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
        }
        blueSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        blueSlider.setMaximumLabelAttributedText(NSAttributedString(string: "255", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]))
        blueSlider.fraction = 0
        blueSlider.shadowOffset = CGSize(width: 0, height: 10)
        blueSlider.shadowBlur = 5
        blueSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        blueSlider.contentViewColor = UIColor.ColorKitBlue()
        blueSlider.isAnimationEnabled = false
        blueSlider.valueViewColor = .white
        blueSlider.addTarget(self, action: #selector(blueSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(blueSlider)
        blueSlider.frame = CGRect(x: screenWidth*0.05, y: greenSlider.frame.maxY+slider_minimum_line_space, width: 0.9*screenWidth, height: 44)
        
        scrollview.contentSize = CGSize(width: 0, height: blueSlider.frame.maxY + 48)
        
        if let path = Bundle.main.path(forResource: "wheels_of_time", ofType: "caf"){
            let baseURL = NSURL(fileURLWithPath: path)
            AudioServicesCreateSystemSoundID(baseURL, &soundId)
            
        }
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private var rf :Int32 = 0
    @objc
    func redSliderValueChanged(redSlider:Slider){
        r = Int32(redSlider.fraction*255)
        if abs(r-rf) >= 5{
            playSystemSound()
            rf = r
        }
        colorPreviewCard.setColor(red: r, green: g, blue: b)
        
    }
    private var gf :Int32 = 0
    @objc
    func greenSliderValueChanged(redSlider:Slider){
        g = Int32(redSlider.fraction*255)
        colorPreviewCard.setColor(red: r, green: g, blue: b)
        if abs(g-gf) >= 5{
            playSystemSound()
            gf = g
        }
    }
    private var bf :Int32 = 0
    @objc
    func blueSliderValueChanged(redSlider:Slider){
        b = Int32(redSlider.fraction*255)
        
        colorPreviewCard.setColor(red: r, green: g, blue: b)
        if abs(b-bf) >= 5{
            playSystemSound()
            bf = b
        }
    }
    
    private func playSystemSound(){
        //        if !isPlaying{
        //
        //            print("asd")
        //            AudioServicesPlaySystemSound(soundId)
        //            isPlaying = true
        //        }
        AudioServicesPlaySystemSound(soundId)
    }
    
    func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        print("Completion")
        isPlaying = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    func showHexInputComponent(){
        view.window?.addSubview(hexColorBlackMaskView)
        
        hexColorBlackMaskView.addSubview(hexInputView)
        hexInputView.setBottomY(screenHeight)
        hexInputView.displayText = colorPreviewCard.hexLabel.text
        hexInputView.initState()
        UIView.animate(withDuration: 0.3) {
            self.hexColorBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    
    @objc
    private func showChooseProjectView(){
        let navi = InteractiveTransitionNavigationController()
        let chooseProjectVC = ChooseProjectViewController { [weak self](project) in
            
            self?.projectBar.setProject(project)
            self?.project = project
        }
        navi.addChild(chooseProjectVC)
        navi.modalPresentationStyle = .fullScreen
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
        hexInputView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.hexColorBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished) in
            self.hexInputView.removeFromSuperview()
            self.hexColorBlackMaskView.removeFromSuperview()
        }
        
    }
    
    @objc
    func save(_ sender: UIBarButtonItem) {
        
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

extension BatchNewCreateColorViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AppendColorHelperDelegate{
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
        //改变保存按钮 enabled 状态
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
/*
extension BatchNewCreateColorViewController:ListAdapterDataSource, AppendColorHelperDelegate, RemoveSectionControllerDelegate{
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return batchCreateHelper.colors
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = CreateSectionHosizontalSectionController()
        sectionController.delegate = self
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyLabel
        
    }
    
    func helerDidUpdate(helper: AppendColorHelper) {
        adapter.performUpdates(animated: true)
    }
    
    func removeSectionControllerWantsRemoved(_ sectionController: CreateSectionHosizontalSectionController) {
       
        let section = adapter.section(for: sectionController)
        
        guard let object = adapter.object(atSection: section) as? MyColor, let index = batchCreateHelper.colors.index(of: object) else {
            return
        }
        
        batchCreateHelper.colors.remove(at: index)
    }
}*/

