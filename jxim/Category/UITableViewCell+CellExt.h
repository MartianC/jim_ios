//
//  UITableViewCell+CellExt.h
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell(UITableViewCell_CellExt)

-(void)createBottomLineWithHeight:(NSUInteger)height left:(NSUInteger)l right:(NSUInteger)r;
-(void)bottomLineLeftToTextlabel;
-(nullable UIView *)bottomLine;

@end

NS_ASSUME_NONNULL_END
