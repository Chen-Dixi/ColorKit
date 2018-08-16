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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        cameraIconImageView = UIImageView(image: UIImage(named: "icon_image"))
        
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
        
        imageScale = image.size.width / frame.width
        
        
        
        addSubview(imageView)
      
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.top.equalTo(self.snp.top).offset(0)
            make.left.equalTo(self.snp.left).offset(0)
        }
        addSubview(pinView)
        loadImagePixelData(image: imageView.image!)
        pinView.frame.origin = CGPoint.zero
    }
    
    
    
    private var isMovingPinView:Bool = false
    private var pinMoveOffset:CGSize = CGSize.zero
    private var locationOffset:CGPoint = CGPoint.zero
    private var bytesPerPixel:Int?
    private var imageScale:CGFloat = 1.0
    private var imageWidth:Int = 0
    var data:UnsafePointer<UInt8>?
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
            
//                if let (r,g,b) = imageView.image?.getPixelColor(pos:CGPoint(x:currentPos.x*imageScale,y:currentPos.y*imageScale)){
//                    rgbCallback(r,g,b)
//                }
            
//                if let color = imageView.colorAtPixel(pos:currentPos){
//                    colorCallback(color)
//                }
            
        default:
            let currentPos = pinView.getBottomCenterPosition()
            if let (r,g,b) = colorAtPixel(image: imageView.image!, pos:CGPoint(x:currentPos.x*imageScale,y:currentPos.y*imageScale)){
                rgbCallback(r,g,b)
            }
            locationOffset = CGPoint.zero
        }
    }
   
    func loadImagePixelData(image:UIImage){
        let pixelData = image.cgImage?.dataProvider?.data
        data = CFDataGetBytePtr(pixelData)
        
        bytesPerPixel = (image.cgImage?.bitsPerPixel ?? 32) / 8
    }
   
    func fillPixelData(image:UIImage){
        let width  = image.cgImage!.width
        
        self.imageWidth = width
        let height = image.cgImage!.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        pixelData = UnsafeMutablePointer<CGFloat>.allocate(capacity: width*height*4)
        let bytesPerPixel = 4
        let bitsPerCompontent = 8
        let bytesPerRow = bytesPerPixel * width
        
        let context  = CGContext.init(data: pixelData, width: width, height: height, bitsPerComponent: bitsPerCompontent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo:   CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue )
        
        context?.setBlendMode(CGBlendMode.copy)
        
        
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        
    }
    
    func colorAtPixel(image:UIImage, pos:CGPoint) -> ( red: Int32, green: Int32,blue:Int32)?{
        let pixelData = image.cgImage?.dataProvider?.data
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let bytesPerPixel = (image.cgImage?.bitsPerPixel ?? 32) / 8
            let pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * bytesPerPixel
        
            let r = Int32(data[pixelInfo])
            let g = Int32(data[pixelInfo+1])
            let b = Int32(data[pixelInfo+2])
            
            
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
