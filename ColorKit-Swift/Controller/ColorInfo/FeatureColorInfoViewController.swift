//
//  FeatureColorInfoViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit

class FeatureColorInfoViewController: BaseViewController,UIViewControllerTransitioningDelegate,UIScrollViewDelegate {
    var tobackgroundColor:UIColor?
    var interactiveTransitionController:CloseColorCardInteractiveTransition!
    var color:FeatureColor!
    var scrollView:UIScrollView!
    var colorInfoViews:[UIView] = []
    
    var currentInfoIndex:Int = 0
    public var colorInfoType:ColorInfoType = .edit
    private var shareBtn:UIButton!
    private var saveBtn:UIButton!

    
    private var pageControl:UIPageControl!
    
    
    
    
    
    
    
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
        
        let colorInfo1 = FeatureColorInfoView(frame: scrollView.bounds, entity: color, style: .NameAndValue)
        colorInfoViews.append(colorInfo1)
        
        let colorInfo2 = FeatureColorInfoView(frame: scrollView.bounds, entity: color, style: .ValueOnly)
        colorInfo2.frame.origin = CGPoint(x: scrollView.frame.width ,y: 0)
        colorInfoViews.append(colorInfo2)
        
        let colorInfo3 = FeatureColorInfoView(frame: scrollView.bounds, entity: color, style: .NameOnly)
        colorInfo3.frame.origin = CGPoint(x: scrollView.frame.width*2 ,y: 0)
        colorInfoViews.append(colorInfo3)
        
        let colorInfo4 = FeatureColorInfoView(frame: scrollView.bounds, entity: color, style: .Clear)
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
        shareBtn.setImage(UIImage(named: "icon_share"), for: UIControl.State.normal)
        shareBtn.tintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        shareBtn.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        saveBtn = UIButton(frame: CGRect.zero)
        saveBtn.setImage(UIImage(named: "icon_download"), for: UIControl.State.normal)
        saveBtn.tintColor = CommonUtil.getClearTextColor(backgroundColor: tobackgroundColor!)
        saveBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        view.addSubview(saveBtn)
        
        saveBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset((screenWidth-78.54) / 2 )
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.75)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(saveBtn.snp.trailing).offset(18.54)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.75)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.5)
            make.width.equalTo(60)
            make.height.equalTo(16)
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
        return CloseFeatureColorCardTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitionController.interaction ? interactiveTransitionController:nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentInfoIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentInfoIndex
    }
}
