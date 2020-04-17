//
//  UIColor+ColorExt.m
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "UIColor+ColorExt.h"

@implementation UIColor(UIColor_ColorExt)


#pragma mark - # 字体

/**
 * 白色背景--黑色文字
 */
+ (UIColor *)text_whitebg_black
{
    return [UIColor blackColor];
}

/**
* 白色背景--蓝色文字
*/
+ (UIColor *)text_whitebg_blue
{
    return RGBColor(26, 74, 189);
}
/**
* 白色背景--浅蓝文字
*/
+ (UIColor *)text_whitebg_blue_light
{
    return RGBColor(88, 158, 255);
}

/**
* 白色背景--灰色文字
*/
+ (UIColor *)text_whitebg_grey
{
    return RGBColor(134, 134, 138);
}
/**
* 白色背景--浅灰文字
*/
+ (UIColor *)text_whitebg_grey_light
{
    return RGBColor(177, 177, 177);
}


/**
* 灰色背景--深灰文字
*/
+ (UIColor *)text_greybg_darkgrey
{
    return RGBColor(134, 134, 138);
}

/**
* 黑色背景--白色文字
*/
+ (UIColor *)text_black_white
{
    return [UIColor whiteColor];
}
/**
 * 错误提示
 */
+ (UIColor *)text_tip_error
{
    return [UIColor redColor];
}


#pragma mark - # 背景

/**
 * 白色背景
 */
+ (UIColor *)background_white
{
    return [UIColor whiteColor];
}
/**
 * 浅灰背景
 */
+ (UIColor *)background_lightgrey
{
    return RGBColor(245, 244, 244);
}
/**
 * 浅蓝背景
 */
+ (UIColor *)background_lightblue
{
    return RGBColor(88, 158, 255);
}
/**
 * 黑色背景
 */
+ (UIColor *)background_black
{
    return RGBColor(74, 74, 74);
}

/**
 * 灰色的线
 */
+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorBlackForMoreMenu {
    return RGBAColor(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForMoreMenuHL {
    return RGBAColor(65, 64, 67, 1.0);
}
+ (UIColor *)colorOrangeColor
{
    return RGBAColor(236, 139, 71,1.0);
}

#pragma mark - # 按钮背景

/**
 * 登录按钮
 */
+ (UIColor *)buttonbg_login
{
    return RGBColor(66, 136, 255);
}

/**
 * 注册按钮
 */
+ (UIColor *)buttonbg_register
{
    return RGBColor(66, 136, 255);
}

/**
 * 获取验证码按钮
 */
+ (UIColor *)buttonLabel_smscode
{
    return RGBColor(88, 158, 255);
}

+ (UIColor *)fitColorWithLightColor:(UIColor *)lightClor darkColor:(UIColor *)darkColor{
    if (@available(iOS 13.0, *)) {
        UIColor *color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
        if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
            return lightClor;
        }
        else {
            return darkColor;
        }}];
        return color;
    }else{
        return lightClor;
    }
}

@end
