//
//  UIFont+FontExt.h
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont(UIFont_FontExt)


#pragma mark - login&register

+ (UIFont *)loginRegister_title;
+ (UIFont *)loginRegister_more;
+ (UIFont *)loginRegister_loginButton;
+ (UIFont *)loginRegister_registerButton;
+ (UIFont *)loginRegister_otherLoginButton;
+ (UIFont *)loginRegister_tipmsg;
+ (UIFont *)loginRegister_region;
+ (UIFont *)loginRegister_smsCode;
+ (UIFont *)loginRegister_phoneNum;


#pragma mark - Common
+ (UIFont *)fontNavBarTitle;
+ (UIFont *)fontBackgroundTip;

#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;

#pragma mark - Friends
+ (UIFont *)fontFriendsUsername;

#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;

#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;


#pragma mark - Chat
+ (UIFont *)fontTextMessageText;


@end

NS_ASSUME_NONNULL_END
