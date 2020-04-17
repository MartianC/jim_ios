//
//  JXRecentSessionSelectViewController.h
//  jxim
//
//  Created by yangfantao on 2020/3/25.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecentSessionSelectFinshBlock)(NSArray *_Nullable);
typedef void(^RecentSessionSelectCancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

/**
 * 创建选项
 */
@interface RecentSessionSelectViewControllerOption : NSObject

@property(nonatomic,copy) NSString *closeButtonTitle;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) BOOL showCreateNewChat;
@property(nonatomic,assign) BOOL canMultipleSel;

@end

/**
 * 委托回调
 */
@protocol RecentSessionSelectViewControllerDelegate <NSObject>

@optional

-(void) onFinsh:(NSArray *_Nullable)userIds;
-(void) onCancel;

@end

/**
 * 最近会话选择控制器
 */
@interface JXRecentSessionSelectViewController : UIViewController

@property(nonatomic,weak) id<RecentSessionSelectViewControllerDelegate> delegate;
@property(nonatomic,copy) RecentSessionSelectFinshBlock onFinsh;
@property(nonatomic,copy) RecentSessionSelectCancelBlock onCancel;

-(instancetype) initWithOption:(RecentSessionSelectViewControllerOption *_Nullable)option;
-(void) show;

@end

NS_ASSUME_NONNULL_END
