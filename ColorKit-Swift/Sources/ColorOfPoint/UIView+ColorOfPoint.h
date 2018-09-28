//
//  UIView+ColorOfPoint.h
//  ColorKit
//
//  Created by Dixi-Chen on 2018/9/26.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ColorOfPoint)

- (void ) colorOfPoint:(CGPoint)point data:(unsigned char * )data;
- (void ) renderColorToData:(unsigned char*) data;
@end
