//
//  FSVerticallyAlignedLabel.h
//  jxim
//
//  Created by yangfantao on 2020/3/29.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VerticalAlignment){
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface FSVerticallyAlignedLabel : UILabel
 
@property (nonatomic,assign) VerticalAlignment verticalAlignment;
 
@end

NS_ASSUME_NONNULL_END
