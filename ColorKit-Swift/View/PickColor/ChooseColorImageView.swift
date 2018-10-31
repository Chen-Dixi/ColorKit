//
//  ChooseColorImageView.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/11.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import SnapKit

class ChooseColorImageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var cameraIconImageView:UIImageView!
    var pinView:UIImageView!
    var imageView:UIImageView!
    var rgbCallback:(Int32,Int32,Int32)->Void = {_,_,_  in }
    var colorCallback:(UIColor)->Void = {_ in}
    var pixel:[CUnsignedChar] = [0,0,0,0]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    var context:CGContext!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
   
    func setupUI(){
        cameraIconImageView = UIImageView(image: UIImage(named: "icon_camera"))
        
        cameraIconImageView.tintColor = UIColor.black
        addSubview(cameraIconImageView)
        backgroundColor = UIColor.white
        imageView = UIImageView()
        
        pinView = UIImageView(image: UIImage(named: "icon_pin"))
        pinView.frame.size = CGSize(width: 45, height: 45)
        pinView.tintColor = UIColor.white
        pinView.addShadowEffect(shadowOpacity: 0.6, shadowOffset: CGSize.zero)
        
        cameraIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.top.equalTo(self.snp.top).offset(10)
            make.width.equalTo(cameraIconImageView.snp.height)
        }
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGestureRecognizer.maximumNumberOfTouches = 1
        pinView.addGestureRecognizer(panGestureRecognizer)
        pinView.isUserInteractionEnabled = true
       
        context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
    }
    
    func setChoosedImage(image:UIImage){
        imageView.removeFromSuperview()
        pinView.removeFromSuperview()
        imageView = nil
        cameraIconImageView.isHidden = true
        
        imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        frame.size = CGSize(width: frame.width, height: frame.width * (imageView.frame.height/imageView.frame.width))
        
       
        
        
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.top.equalTo(self.snp.top).offset(0)
            make.left.equalTo(self.snp.left).offset(0)
        }
        
        
        if let newImage = self.imageView.snapshotImageAfterScreenUpdates(afterUpdates: true){
            imageView.image = newImage
        }
        
        
        
        addSubview(pinView)
        //loadImagePixelData()
        pinView.frame.origin = CGPoint.zero
    }
    
    
    
    private var isMovingPinView:Bool = false
    private var pinMoveOffset:CGSize = CGSize.zero
    private var locationOffset:CGPoint = CGPoint.zero
    private var bytesPerPixel:Int?
    private var imageScale:CGFloat = 1.0
    private var imageWidth:Int = 0
    var data:UnsafeMutablePointer<UInt8>!
    var initializeCount:Int=1
    var pixelData:UnsafeMutablePointer<CGFloat>? = nil
    @objc
    func panGesture(_ sender: UIPanGestureRecognizer){
        let state = sender.state
        let position = sender.location(in: self)
        
        switch state {
        case .began:
            //loadImagePixelData(image: imageView.image!)
            locationOffset = CGPoint(x: position.x - pinView.center.x, y: position.y - pinView.center.y)
            
        case .changed:
            
                let x = max(0,min(bounds.width, position.x - locationOffset.x))
                let y = max(0-pinView.frame.height/2,min(position.y - locationOffset.y,bounds.height-2-pinView.frame.height/2))
                pinView.center = CGPoint(x:x, y: y)
                let currentPos = pinView.getBottomCenterPosition()
                if let (r,g,b) = colorAtPixel(pos: currentPos){
                    rgbCallback(r,g,b)
                }
            
            
        default:
            

            locationOffset = CGPoint.zero
        }
    }
    
    func colorAtPixel( pos:CGPoint) -> ( red: Int32, green: Int32,blue:Int32)?{

        context.translateBy(x: -pos.x, y: -pos.y)
        imageView.layer.render(in: context)
        let r = Int32(pixel[0])
        let g = Int32(pixel[1])
        let b = Int32(pixel[2])
        context.translateBy(x: pos.x, y: pos.y)
        return (r,g,b)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view == nil{
            for subview in subviews{
                let tp = subview.convert(point, from: self)
                if subview.bounds.contains(tp){
                    view =  subview
                }
            }
        }
        return view
    }
}
