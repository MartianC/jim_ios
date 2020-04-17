//
//  MoreMenuView.h
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@class MoreMenuView;
@protocol MoreMenuViewDelegate <NSObject>

- (void)addMenuView:(MoreMenuView *)addMenuView didSelectedItem:(MoreMenuItem *)item;

@end

@interface MoreMenuView : UIView

@property (nonatomic, assign) id<MoreMenuViewDelegate>delegate;
@property (nonatomic, copy) void (^itemSelectedAction)(MoreMenuView *addMenuView, MoreMenuItem *item);

/**
 *  显示AddMenu
 *
 *  @param view 父View
 */
- (void)showInView:(UIView *)view;

/**
 *  是否正在显示
 */
- (BOOL)isShow;

/**
 *  隐藏
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
