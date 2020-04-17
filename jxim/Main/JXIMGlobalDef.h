//
//  JXIMGlobalDef.h
//  jxim
//
//  Created by yangfantao on 2020/3/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "NSString+StringExt.h"
#import "NSDictionary+DictionaryExt.h"

#ifndef JXIMGlobalDef_h
#define JXIMGlobalDef_h

//Macro def

#pragma mark - # 快捷方法

// 单例声明
#define JXSingleton_Declare(className)              \
+ (className *)sharedInstance;                      \
- (instancetype)init NS_UNAVAILABLE;                \
+ (instancetype)new NS_UNAVAILABLE;


// 单例定义
#define JXSingleton_Impl(className)                 \
+ (className *)sharedInstance                       \
{                                                   \
    static className *singletonInstance;            \
    static dispatch_once_t onceToken;               \
    dispatch_once(&onceToken, ^{                    \
        singletonInstance = [[self alloc] init];    \
    });                                             \
    return singletonInstance;                       \
}

// 创建浅灰色线
#define UILine_Block                                \
UIView *(^createLine)(void) = ^UIView *(){          \
    UIView *line = [[UIView alloc] init];           \
    line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];\
    return line;\
};

// tableView Cell线
#define TableViewCellUILine_Block                                \
UIView *(^createLine)(void) = ^UIView *(){          \
    UIView *line = [[UIView alloc] init];           \
    line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];\
    return line;\
};


#define EDGE_LINE                                   20.0f
#define JX_UserDataManager                          [JXUserDataManager sharedInstance]
#define PopoverVCBGColor                            RGBColor(74, 74, 74)
#define HeightForHeaderInSection(section)           (0 == section ? 0 : 12)
#define SearchBarHeight                             55.0f
#define Gender_Male                                 1
#define Gender_Female                               2
#define Message_Font_Size                           14        // 普通聊天文字大小
#define Notification_Font_Size                      10   // 通知文字大小
#define Message_Detail_Font_Size                    11   // 聊天记录消息文字大小
#define Chatroom_Message_Font_Size                  16 // 聊天室聊天文字大小

#define UIScreenWidth                              [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight                             [UIScreen mainScreen].bounds.size.height
#define UISreenWidthScale                          UIScreenWidth / 320

//本地存储键
#define UserDefaultsKey_StatusData                  @"__UserDefaultsKey_StatusData__"

//是否是ios13
#define IOS_13                                      @available(iOS 13.0, *)
#define IOS11                                       ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0)

//获取ios13状态栏尺寸
#define STATUS_BAR_SIZE_IOS_13                      [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame.size

//获取<ios13版本状态栏尺寸
#define STATUS_BAR_SIZE_IOS_LT13                    [[UIApplication sharedApplication] statusBarFrame].size

#define STATUS_BAR_SIZE                             (IOS_13 ? STATUS_BAR_SIZE_IOS_13 : STATUS_BAR_SIZE_IOS_LT13)

//定义弱引用
#define WEAK_SELF                                   __weak typeof(self) weakSelf = self
#define WeakSelf(type)                              __weak typeof(type) weak##type = type;
#define StrongSelf(type)                            __strong typeof(type) strong##type = type;

//显示主UI
#define ShowMainViewController  \
JXMainTBC *mainTBC = [[JXMainTBC alloc] init];  \
typedef void (^Animation)(void);    \
UIWindow* window = UIApplication.sharedApplication.keyWindow;   \
mainTBC.modalTransitionStyle = UIModalTransitionStyleCoverVertical; \
[UIView transitionWithView:window   \
                  duration:0.1  \
                   options:UIViewAnimationOptionTransitionCrossDissolve \
                animations:^{   \
                  BOOL oldState = [UIView areAnimationsEnabled];    \
                  [UIView setAnimationsEnabled:NO]; \
                  window.rootViewController = mainTBC;  \
                  [UIView setAnimationsEnabled:oldState];   \
} completion:nil];

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//Const def

//Enum def
typedef NS_ENUM(NSInteger,JIMAccountStatus){
    JIMAccountStatusNormal = 0,
    JIMAccountStatusNeedPerfectDatum = 100
};

#endif /* JXIMGlobalDef_h */
