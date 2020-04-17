//
//  JXMineDef.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//
#import "JXIMGlobalDef.h"
#import "JXContactDef.h"

#ifndef JXMineDef_h
#define JXMineDef_h


#pragma mark - ViewController

//data
#define JXPortraitCellHeight (300.f + STATUS_BAR_SIZE.height)
#define JXWalletBalanceCellHeight (200.f + STATUS_BAR_SIZE.height)
#define JXSettingAvatarCellHeight 70.f
#define NotchHeight STATUS_BAR_SIZE
#define SectionHeaderHeight 10.f


#pragma mark - TableData

//row key
#define Icon        @"icon"
#define ShowRedDot  @"showRedDot"
#define ShowBottomLine  @"showBottomLine"
#define AccessoryType  @"accessoryType"
//data
#define JXUIRowHeight  ContactRowHeight_System
#define JXUIHeaderHeight 0.00001f//44.f
#define JXUIFooterHeight 10.f//44.f
#define JXUIFooterHeight_WithFooterTitle 28.f//44.f
#define AccessoryType_Switch 1

#pragma mark - SubView

//底板高度
#define BaseViewHeight 100.f
//头像大小
#define AvatarSize  100.f
//设置页面头像大小
#define SettingAvatarSize 50.f

//头像边框大小
#define AvatarBorderWidth 2.f
//头像编辑按钮大小
#define AvatarEditerSize  20.f
//昵称字体大小
#define NameFontSize 20.f
//账号字体大小
#define AccountFontSize 14.f
//输入框文字大小
#define InputeFontSize 16.f
//元素间距
#define OffsetSize 15.f

#define OffsetSize_Small 5.f

#define OffsetSize_Big 30.f

#define TableTextOffset 100.f

#define SMSCodeBtnWidth 100.f

#define BigButtonHeight 40.f

#define SmallFontSize 14.f

#pragma mark - BalanceView

//按钮高度
#define BalanceButtonHeight 50.f

#endif /* JXMineDef_h */

