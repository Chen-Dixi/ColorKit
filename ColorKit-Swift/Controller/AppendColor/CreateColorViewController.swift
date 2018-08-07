//
//  CreateColorViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/29.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

public enum ColorPickerType: Int{
    case create
    case edit
    case view
}

class CreateColorViewController: BaseViewController {

    var colorBoardView:UIView!
    var redSliderView:CapsuleSliderView!
    var greenSliderView:CapsuleSliderView!
    var blueSliderView:CapsuleSliderView!
    private var r:CGFloat=0
    private var g:CGFloat=0
    private var b:CGFloat=0
    var color:Color?
    var project:Project?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    public var pickerType:ColorPickerType = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        colorBoardView = UIView(frame: CGRect.zero)
        
        redSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitRed(), slidingCallback: {[weak self] (redValue) in
            if let strongSelf = self{
                strongSelf.r = CGFloat(redValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
        })
        
        greenSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitGreen(), slidingCallback: {[weak self] (greenValue) in
            if let strongSelf = self{
                strongSelf.g = CGFloat(greenValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
            
        })
        
        blueSliderView = CapsuleSliderView(frame: CGRect.zero, startValue: 0,color: UIColor.ColorKitBlue(), slidingCallback: {[weak self] (blueValue) in
            if let strongSelf = self{
                strongSelf.b = CGFloat(blueValue)
                strongSelf.colorBoardView.backgroundColor = UIColor(red: strongSelf.r/255, green: strongSelf.g/255, blue: strongSelf.b/255, alpha: 1.0)
            }
        })
        
        view.addSubview(colorBoardView)
        view.addSubview(redSliderView)
        view.addSubview(greenSliderView)
        view.addSubview(blueSliderView)
        
        if let color = color{
            redSliderView.setBarValue(value: Int(color.r))
            greenSliderView.setBarValue(value: Int(color.g))
            blueSliderView.setBarValue(value: Int(color.b))
            nameTextField.text = color.name
        }
        updateFrame()
        
        if pickerType == .view{
            navigationItem.rightBarButtonItem = nil
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func updateFrame(){
        colorBoardView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(view.snp.leading).offset(60)
            make.width.equalTo(colorBoardView.snp.height)
        }
        greenSliderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(colorBoardView.snp.centerX)
            make.top.equalTo(colorBoardView.snp.bottom).offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(greenSliderView.snp.height).multipliedBy(0.4)
        }
        redSliderView.snp.makeConstraints { (make) in
            make.centerY.equalTo(greenSliderView.snp.centerY)
            make.left.equalTo(colorBoardView.snp.left)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(redSliderView.snp.height).multipliedBy(0.4)

        }
        blueSliderView.snp.makeConstraints { (make) in
            make.centerY.equalTo(greenSliderView.snp.centerY)
            make.right.equalTo(colorBoardView.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.width.equalTo(blueSliderView.snp.height).multipliedBy(0.4)

        }
        
        let radius:CGFloat = 8.0
        redSliderView.setCorderRaduis(radius: radius)
        greenSliderView.setCorderRaduis(radius: radius)
        blueSliderView.setCorderRaduis(radius: radius)
        
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }
    
    //MARK: - operation
    public var nextSeq:Int32?
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Color",
                                       in: managedContext)!
        
        if pickerType == .create{
            let newColor = Color(entity: entity, insertInto: managedContext)
            
            newColor.setValue(nameTextField.text!, forKey: "name")
            newColor.setValue(r, forKey: "r")
            newColor.setValue(g, forKey: "g")
            newColor.setValue(b, forKey: "b")
            newColor.setValue(project, forKey: "project")
            newColor.setValue(false, forKey: "collect")
            if let seq = nextSeq{
                newColor.setValue(seq, forKey: "seq")
            }
            
            do{
                try managedContext.save()
                
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else{
            if let color = color{
                color.setValue(nameTextField.text!, forKey: "name")
                color.setValue(r, forKey: "r")
                color.setValue(g, forKey: "g")
                color.setValue(b, forKey: "b")
            }
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateData"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
}

