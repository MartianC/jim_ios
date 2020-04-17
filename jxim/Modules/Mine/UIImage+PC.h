//
//  UIImage+PC.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/11.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PC)

+ (instancetype)pc_imageWithColor:(UIColor *)color;
+ (instancetype)pc_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
