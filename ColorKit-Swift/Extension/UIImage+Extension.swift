//
//  UIImage+Extension.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics
extension UIImage{
    class func imageWithColor(color:UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func getPixelColor(pos:CGPoint) ->( red: Int32, green: Int32,blue:Int32){
        let pixelData = cgImage?.dataProvider?.data
        
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = cgImage!.bitsPerPixel / 8
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * bytesPerPixel
        
        let r = Int32(data[pixelInfo])
        let g = Int32(data[pixelInfo+1])
        let b = Int32(data[pixelInfo+2])
        
        
        return (r,g,b)
    }
    
    func scaleImage(toSize:CGSize)-> UIImage{
        UIGraphicsBeginImageContext(toSize)
        draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func colorAtPixel(pos:CGPoint) ->( red: CGFloat, green: CGFloat,blue:CGFloat)?{
        if !CGRect(x: 0, y: 0, width: size.width, height: size.height).contains(pos){
            return nil
        }
        
        let pointX = trunc(pos.x)
        let pointY = trunc(pos.y)
        
        
        let width  = size.width
        let height = size.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixelData:UnsafeMutablePointer<CGFloat> = UnsafeMutablePointer<CGFloat>.allocate(capacity: 4)
        let bytesPerPixel = 4
        let bitsPerCompontent = 8
        let bytesPerRow = bytesPerPixel * 1
        
        let context  = CGContext.init(data: pixelData, width: 1, height: 1, bitsPerComponent: bitsPerCompontent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo:   CGImageAlphaInfo.premultipliedLast.rawValue )
        
        //context?.setBlendMode(CGBlendMode.copy)
        context?.translateBy(x: -pointX, y: -pointY)
        
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
       
        let r = CGFloat(pixelData[0]) / 255.0
        let g = CGFloat(pixelData[1]) / 255.0
        let b = CGFloat(pixelData[2]) / 255.0
        print((r,g,b))
        return (r,g,b)
    }
}
