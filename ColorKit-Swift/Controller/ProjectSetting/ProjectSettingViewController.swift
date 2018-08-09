//
//  ProjectSettingViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/2.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import KeyboardMan
class ProjectSettingViewController: UITableViewController {

    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    var project:Project?
    
    var badgeboardView:BadgeBoardView!
    var titleInputView:TextFieldAndButtonView!
    
    lazy var badgeBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    
    lazy var titleBlackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return blackMask
    }()
    
    let keyboardMan = KeyboardMan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: footerFrame1)
        tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        
        // Do any additional setup after loading the view.
        projectNameLabel.text = project?.name
        badgeImageView.image = UIImage(named: project?.badgeName ?? "badge_game")
        badgeboardView = BadgeBoardView(frame: CGRect(x: screenWidth*0.05,y: screenHeight, width: screenWidth*0.9, height: screenWidth*0.9) ){
            [weak self] ( badge_name) in
            if let strongSelf = self{
                strongSelf.project?.badgeName = badge_name
                strongSelf.saveContext()
                strongSelf.badgeImageView.image = UIImage(named: badge_name)
                strongSelf.tapHandler2()// removeFromSubview
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
            }
        }
        titleInputView = TextFieldAndButtonView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 45) ) {
            [weak self] (name) in
            if let strongSelf = self{
                strongSelf.project?.name = name
                strongSelf.saveContext()
                strongSelf.projectNameLabel.text = name
                strongSelf.tapHandler1()// removeFromSubview
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
            }
        }
        
        badgeboardView.layer.cornerRadius = 8
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler1))
        titleBlackMaskView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapHandler2))
        badgeBlackMaskView.addGestureRecognizer(tapGesture2)
//        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(motion == UIEventSubtype.motionShake){
            dismiss(animated: true, completion: nil)
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
    
    private enum Section:Int{
        case ProjectSetting
    }
    
    private enum ProjectSettingRow: Int{
        case Name
        case Badge
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        guard let section = Section(rawValue:indexPath.section) else{
            return
        }
        
        switch section{
        case .ProjectSetting:
            guard let row = ProjectSettingRow(rawValue:indexPath.row) else{
                return
            }
            
            switch row{
            case .Name:
                //弹出键盘，输入名称
                showNameInputComponent()
            case .Badge:
                //弹出board，选择徽章
                showBadgeSelector()
            }
        }
    }
    
    func showNameInputComponent(){
        view.window?.addSubview(titleBlackMaskView)
        
        titleBlackMaskView.addSubview(titleInputView)
        titleInputView.setBottomY(screenHeight)
        titleInputView.displayText = project?.name
        titleInputView.initState()
        UIView.animate(withDuration: 0.3) {
            self.titleBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    
    func showBadgeSelector(){
        view.window?.addSubview(badgeBlackMaskView)
        badgeBlackMaskView.addSubview(badgeboardView)
        UIView.animate(withDuration: 0.3) {
            self.badgeboardView.frame.origin.y = screenHeight-(36+screenWidth*0.9)
            self.badgeBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
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
    
    @objc
    func tapHandler2(){
        UIView.animate(withDuration: 0.3, animations: {
            self.badgeboardView.frame.origin.y = screenHeight
            self.badgeBlackMaskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished) in
            self.badgeboardView.removeFromSuperview()
            self.badgeBlackMaskView.removeFromSuperview()
        }
        
        
    }
    
    @IBAction func finishAndDismiss(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    
}
