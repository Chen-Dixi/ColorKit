//
//  ColorCardViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/16.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import KeyboardMan

public enum ColorInfoType: Int{
    
    case edit
    case view
}

class ColorInfoViewController: BaseViewController,UIViewControllerTransitioningDelegate,UIScrollViewDelegate {

    var tobackgroundColor:UIColor?
    var interactiveTransitionController:CloseColorCardInteractiveTransition!
    var color:Color!
    var scrollView:UIScrollView!
    var colorInfoViews:[UIView] = []
    
    var currentInfoIndex:Int = 0
    public var colorInfoType:ColorInfoType = .edit
    private var shareBtn:UIButton!
    private var saveBtn:UIButton!
    private var editBtn:UIButton!
    
    private var pageControl:UIPageControl!
    
    var titleInputView:TextFieldAndButtonView!
    
    lazy var titleBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    
    let keyboardMan = KeyboardMan()
    
    /*
     
     */
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        modalPresentationStyle = .custom
        scrollView = UIScrollView(frame: view.bounds)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //scroview 添加表盘
        scrollView.contentSize = CGSize(width: screenWidth*4, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        interactiveTransitionController = CloseColorCardInteractiveTransition()
        interactiveTransitionController.addPanGesture(for: self)
        
        let colorInfo1 = ColorInfoView(frame: scrollView.bounds, entity: color, style: .NameAndValue)
        colorInfoViews.append(colorInfo1)
        
        let colorInfo2 = ColorInfoView(frame: scrollView.bounds, entity: color, style: .ValueOnly)
        colorInfo2.frame.origin = CGPoint(x: scrollView.frame.width ,y: 0)
        colorInfoViews.append(colorInfo2)
        
        let colorInfo3 = ColorInfoView(frame: scrollView.bounds, entity: color, style: .NameOnly)
        colorInfo3.frame.origin = CGPoint(x: scrollView.frame.width*2 ,y: 0)
        colorInfoViews.append(colorInfo3)
        
        let colorInfo4 = ColorInfoView(frame: scrollView.bounds, entity: color, style: .Clear)
        colorInfo4.frame.origin = CGPoint(x: scrollView.frame.width*3 ,y: 0)
        colorInfoViews.append(colorInfo4)
        
        scrollView.addSubview(colorInfo1)
        scrollView.addSubview(colorInfo2)
        scrollView.addSubview(colorInfo3)
        scrollView.addSubview(colorInfo4)
        
        if let gestures = view.gestureRecognizers{
            for gesture in gestures{
                if gesture.isKind(of: UIScreenEdgePanGestureRecognizer.classForCoder()){
                    scrollView.panGestureRecognizer.require(toFail: gesture)
                    break
                }
            }
        }
        
        pageControl = UIPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = colorInfoViews.count
        pageControl.currentPageIndicatorTintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        pageControl.pageIndicatorTintColor = UIColor.lightText
        view.addSubview(pageControl)
        pageControl.defersCurrentPageDisplay = true
//        let button = UIButton(frame: CGRect(x: buttonWidth*CGFloat(count%col), y: buttonWidth*CGFloat(count/col), width: buttonWidth, height: buttonWidth))
//        button.setImage(UIImage(named: badge_Names[count]), for: UIControlState.normal)
//        button.tintColor = UIColor.ColorKitRed()
//        button.tag = count
//        button.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
        
        shareBtn = UIButton(frame: CGRect.zero)
        shareBtn.setImage(UIImage(named: "icon_share"), for: UIControlState.normal)
        shareBtn.tintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        shareBtn.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        view.addSubview(shareBtn)
        
        saveBtn = UIButton(frame: CGRect.zero)
        saveBtn.setImage(UIImage(named: "icon_download"), for: UIControlState.normal)
        saveBtn.tintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        saveBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        view.addSubview(saveBtn)
        
        
        editBtn = UIButton(frame: CGRect.zero)
        editBtn.setImage(UIImage(named: "icon_edit"), for: UIControlState.normal)
        editBtn.tintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        editBtn.addTarget(self, action: #selector(showNameInputComponent), for: .touchUpInside)
        view.addSubview(editBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.618)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(saveBtn.snp.trailing).offset(18.54)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.618)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        editBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(saveBtn.snp.leading).offset(-18.54)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.618)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.5)
            make.width.equalTo(60)
            make.height.equalTo(16)
        }
        
        titleInputView = TextFieldAndButtonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45) ) {
            [weak self] (name) in
            if let strongSelf = self{
                strongSelf.color.name = name
                strongSelf.saveContext()
                strongSelf.updateName()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
                strongSelf.tapHandler1()// removeFromSubview
            }
        }
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler1))
        titleBlackMaskView.addGestureRecognizer(tapGesture1)
        
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
        
        if colorInfoType == .view{
            editBtn.isHidden = true
            saveBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX).offset(-24.27)
            }
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func saveImage(_ sender: UIButton){
        sender.antiMultiplyTouch(delay: 1, closure: {})
        let image = colorInfoViews[currentInfoIndex].snapshotImageAfterScreenUpdates(afterUpdates: false)
        
        if let image = image{
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageComplete(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc
    private func saveImageComplete(image:UIImage, didFinishSavingWithError error:NSError?,contextInfo: AnyObject){
        if error != nil{
            invokeNotificationFeedback(type: .warning)
            
        }else{
            invokeNotificationFeedback(type: .success)
            noticeTop("图片已保存到相册")
            showReview()
        }
    }

    @objc
    func shareImage(_ sender:UIButton){
        sender.antiMultiplyTouch(delay: 1, closure: {})
        let image = colorInfoViews[currentInfoIndex].snapshotImageAfterScreenUpdates(afterUpdates: false)
        
        if let image = image{
            invokeSelectionFeedback()
            
            
            let items = [image] as [Any]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.completionWithItemsHandler = {
                activity, success, items, error in
            }
            activityVC.popoverPresentationController?.sourceView = shareBtn
            activityVC.popoverPresentationController?.sourceRect = CGRect.zero
            present(activityVC, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc
    func tapHandler(_gesture:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func showNameInputComponent(){
        view.window?.addSubview(titleBlackMaskView)
        
        titleBlackMaskView.addSubview(titleInputView)
        titleInputView.setBottomY(screenHeight)
        titleInputView.displayText = color.name
        titleInputView.initState()
        UIView.animate(withDuration: 0.3) {
            self.titleBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
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
    
    private func updateName(){
        for view in colorInfoViews{
            if let colorInfoView = view as? ColorInfoView{
                colorInfoView.updateName()
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OpenColorCardTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        return CloseColorCardTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitionController.interaction ? interactiveTransitionController:nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentInfoIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentInfoIndex
    }
    
}
