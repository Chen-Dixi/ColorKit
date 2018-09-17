//
//  NewCreateColorViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/20.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import KeyboardMan
import Slider
import CoreData

class NewCreateColorViewController: PresentBaseViewController {
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
    var keyboardMan = KeyboardMan()
    
    var redSlider:Slider!
    var greenSlider:Slider!
    var blueSlider:Slider!
    
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
        colorPreviewCard = UINib(nibName: "CardPreview", bundle: nil).instantiate(withOwner: nil, options: nil).last as! CardPreview
        colorPreviewCard.frame = CGRect(x: screenWidth*0.05, y: 60, width: screenWidth*0.9, height: 120)
        
        colorPreviewCard.layer.cornerRadius = 8
        colorPreviewCard.layer.shadowColor = UIColor.lightGray.cgColor
        colorPreviewCard.layer.shadowOffset = CGSize.zero
        
        colorPreviewCard.layer.shadowOpacity = 0.8
        scrollview.addSubview(colorPreviewCard)
        projectBar = UINib(nibName: "ProjectBar", bundle: nil).instantiate(withOwner: nil, options: nil).last as! ProjectBar
        projectBar.frame = CGRect(x: 1, y: 1, width: screenWidth, height: 40)
        projectBar.setProject(project)
        scrollview.addSubview(projectBar)

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(showNameInputComponent))
        colorPreviewCard.addGestureRecognizer(tap)
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
        redSlider.addTarget(self, action: #selector(redSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(redSlider)
        redSlider.frame = CGRect(x: screenWidth*0.05, y: 240, width: 0.9*screenWidth, height: 44)
        
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
        greenSlider.addTarget(self, action: #selector(greenSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(greenSlider)
        greenSlider.frame = CGRect(x: screenWidth*0.05, y: redSlider.frame.maxY+50, width: 0.9*screenWidth, height: 44)
        
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
        blueSlider.valueViewColor = .white
        blueSlider.addTarget(self, action: #selector(blueSliderValueChanged), for: .valueChanged)
        scrollview.addSubview(blueSlider)
        blueSlider.frame = CGRect(x: screenWidth*0.05, y: greenSlider.frame.maxY+50, width: 0.9*screenWidth, height: 44)
        
        scrollview.contentSize = CGSize(width: 0, height: blueSlider.frame.maxY + 48)
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .plain, target: self, action: #selector(save))
    }

    @objc
    func redSliderValueChanged(redSlider:Slider){
        r = Int32(redSlider.fraction*255)
        
        colorPreviewCard.setColor(red: r, green: g, blue: b)
    }
    
    @objc
    func greenSliderValueChanged(redSlider:Slider){
        g = Int32(redSlider.fraction*255)
        
        colorPreviewCard.setColor(red: r, green: g, blue: b)
    }
    
    @objc
    func blueSliderValueChanged(redSlider:Slider){
        b = Int32(redSlider.fraction*255)
        
        colorPreviewCard.setColor(red: r, green: g, blue: b)
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
    func save(_ sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Color",
                                       in: managedContext)!
        
        
        let newColor = Color(entity: entity, insertInto: managedContext)
        
        newColor.setValue(colorPreviewCard.titleLabel.text!, forKey: "name")
        newColor.setValue(r, forKey: "r")
        newColor.setValue(g, forKey: "g")
        newColor.setValue(b, forKey: "b")
        newColor.setValue(project, forKey: "project")
        newColor.setValue(false, forKey: "collect")
        newColor.setValue(Date(), forKey: "createdAt")
        
        saveContext()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
        dismiss(animated: true, completion: nil)
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
