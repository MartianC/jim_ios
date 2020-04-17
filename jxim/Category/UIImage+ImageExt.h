//
//  UIImage+ImageExt.h
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(UIImage_ImageExt)

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)thumbnailWithImageWithoutScale:(CGSize)asize;

@end

NS_ASSUME_NONNULL_END
