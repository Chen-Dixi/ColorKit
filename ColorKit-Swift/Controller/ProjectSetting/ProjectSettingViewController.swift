//
//  ProjectSettingViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/2.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ProjectSettingViewController: UITableViewController {

    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    var project:Project?
    
    var badgeboardView:BadgeBoardView!
    var titleInputView:TextFieldAndButtonView!
    
    lazy var blackMaskView:UIView = {
        let blackMask = UIView(frame: UIScreen.main.bounds)
        blackMask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return blackMask
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: footerFrame1)
        tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        
        // Do any additional setup after loading the view.
        projectNameLabel.text = project?.name
        badgeImageView.image = UIImage(named: project?.badgeName ?? "badge_game")
        badgeboardView = BadgeBoardView(frame: CGRect(x: screenWidth*0.05,y: screenHeight-(36+screenWidth*0.9), width: screenWidth*0.9, height: screenWidth*0.9) ){
            [weak self] ( badge_name) in
            if let strongSelf = self{
                strongSelf.project?.badgeName = badge_name
                strongSelf.saveContext()
                strongSelf.badgeImageView.image = UIImage(named: badge_name)
                strongSelf.tapHandler()// removeFromSubview
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
            }
        }
        titleInputView = TextFieldAndButtonView(frame: CGRect(x: screenWidth*0.05, y: 90, width: screenWidth*0.9, height: 64) ) {
            [weak self] (name) in
            if let strongSelf = self{
                strongSelf.project?.name = name
                strongSelf.saveContext()
                strongSelf.projectNameLabel.text = name
                strongSelf.tapHandler()// removeFromSubview
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
            }
        }
        
        badgeboardView.layer.cornerRadius = 8
        titleInputView.layer.cornerRadius = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        blackMaskView.addGestureRecognizer(tapGesture)

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
        view.window?.addSubview(blackMaskView)
        blackMaskView.addSubview(titleInputView)
        titleInputView.displayText = project?.name
        titleInputView.initState()
    }
    
    func showBadgeSelector(){
        view.window?.addSubview(blackMaskView)
        blackMaskView.addSubview(badgeboardView)
    }
    
    @objc
    func tapHandler(){
        badgeboardView.removeFromSuperview()
        titleInputView.removeFromSuperview()
        blackMaskView.removeFromSuperview()
    }
    
    @IBAction func finishAndDismiss(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
    
}
