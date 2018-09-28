//
//  UIView+ColorOfPoint.m
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/26.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//


#import "UIView+ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ColorOfPoint)

- (void) colorOfPoint:(CGPoint)point data:(unsigned char * )data
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(data, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    //UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    //return pixel;
}
- (void ) renderColorToData:(unsigned char*) data
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(data,self.frame.size.width, self.frame.size.height, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    //CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
}
@end
