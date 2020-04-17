//
//  UIFont+FontExt.m
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "UIFont+FontExt.h"

@implementation UIFont(UIFont_FontExt)


+ (UIFont *)loginRegister_title
{
    return [UIFont systemFontOfSize:28.0f];
}
+ (UIFont *)loginRegister_more
{
    return [UIFont systemFontOfSize:16.0f];
}
+ (UIFont *)loginRegister_loginButton
{
    return [UIFont systemFontOfSize:16.0f];
}
+ (UIFont *)loginRegister_registerButton
{
    return [UIFont systemFontOfSize:16.0f];
}
+ (UIFont *)loginRegister_otherLoginButton
{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)loginRegister_tipmsg
{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)loginRegister_region
{
    return [UIFont systemFontOfSize:16.0f];
}
+ (UIFont *)loginRegister_smsCode
{
    return [UIFont systemFontOfSize:14.0f];
}
+ (UIFont *)loginRegister_phoneNum
{
    return [UIFont systemFontOfSize:26.0f];
}

//
//
//=============================
//
//

+ (UIFont *) fontNavBarTitle
{
    return [UIFont boldSystemFontOfSize:17.5f];
}

+ (UIFont *)fontBackgroundTip
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontConversationUsername
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontConversationDetail
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontConversationTime
{
    return [UIFont systemFontOfSize:12.5f];
}

+ (UIFont *) fontFriendsUsername
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontMineNikename
{
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontMineUsername
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontSettingHeaderAndFooterTitle
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *)fontTextMessageText
{
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = 16.0f;
    }
    return [UIFont systemFontOfSize:size];
}

@end
