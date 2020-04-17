//
//  UIColor+ColorExt.h
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBColor(r, g, b)           [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(UIColor_ColorExt)


#pragma mark - # 字体

/**
 * 白色背景--黑色文字
 */
+ (UIColor *)text_whitebg_black;

/**
* 白色背景--蓝色文字
*/
+ (UIColor *)text_whitebg_blue;
/**
* 白色背景--浅蓝文字
*/
+ (UIColor *)text_whitebg_blue_light;

/**
* 白色背景--灰色文字
*/
+ (UIColor *)text_whitebg_grey;
/**
* 白色背景--浅灰文字
*/
+ (UIColor *)text_whitebg_grey_light;


/**
* 灰色背景--深灰文字
*/
+ (UIColor *)text_greybg_darkgrey;
/**
* 黑色背景--白色文字
*/
+ (UIColor *)text_black_white;
/**
 * 错误提示
 */
+ (UIColor *)text_tip_error;


#pragma mark - # 背景

/**
 * 白色背景
 */
+ (UIColor *)background_white;
/**
 * 浅灰背景
 */
+ (UIColor *)background_lightgrey;
/**
 * 浅蓝背景
 */
+ (UIColor *)background_lightblue;
/**
 * 黑色背景
 */
+ (UIColor *)background_black;
/**
 * 灰色的线
 */
+ (UIColor *)colorGrayLine;
+ (UIColor *)colorBlackForMoreMenu;
+ (UIColor *)colorBlackForMoreMenuHL;
+ (UIColor *)colorOrangeColor;


#pragma mark - # 按钮背景

/**
 * 登录按钮
 */
+ (UIColor *)buttonbg_login;

/**
 * 注册按钮
 */
+ (UIColor *)buttonbg_register;


#pragma mark - # 按钮文字

/**
 * 获取验证码按钮
 */
+ (UIColor *)buttonLabel_smscode;

@end

NS_ASSUME_NONNULL_END
