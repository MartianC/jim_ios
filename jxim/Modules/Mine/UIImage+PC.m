//
//  UIImage+PC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/11.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "UIImage+PC.h"


@implementation UIImage (PC)

+ (instancetype)pc_imageWithColor:(UIColor *)color {
    return [self pc_imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (instancetype)pc_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
