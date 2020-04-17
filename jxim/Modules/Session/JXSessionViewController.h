//
//  JXSessionViewController.h
//  jxim
//
//  Created by yangfantao on 2020/3/24.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <NIMKit/NIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXSessionViewController : NIMSessionViewController

@property (nonatomic,assign) BOOL disableCommandTyping;  //需要在导航条上显示“正在输入”

@property (nonatomic,assign) BOOL disableOnlineState;  //需要在导航条上显示在线状态

@end

NS_ASSUME_NONNULL_END
