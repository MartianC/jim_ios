//
//  JXMineSettingNotification.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingNotification.h"
#import "JXUserDataManager.h"
#import <NIMKit.h>
#import <SVProgressHUD.h>

@interface JXMineSettingNotification ()

@property (nonatomic,strong) JIMAccount *user;

@end

@implementation JXMineSettingNotification

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"新消息通知";
}

- (void)loadData {
    self.user = JX_UserDataManager.userData;
    NSArray *data = @[
        @{
            HeaderTitle  :@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent   :@[
                @{
                    Title         : @"新消息通知",
                    CellAction    : @"onTouchNewMsgCell:",
                    ShowAccessory : @(YES),
                    AccessoryType : @(1),
                },
            ],
            FooterTitle:@"关闭后，手机将不再接受新消息通知",
            FooterHeight :@JXUIFooterHeight_WithFooterTitle,
        },
        @{
            HeaderTitle  :@"",
            RowContent   :@[
                @{
                    Title         : @"通知显示消息详情",
                    CellAction    : @"onTouchMsgDetailCell:",
                    ShowAccessory : @(YES),
                    AccessoryType : @(1),
                },
            ],
            FooterTitle:@"关闭后，通知将不再显示消息详情",
            FooterHeight :@JXUIFooterHeight_WithFooterTitle,
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"声音",
                    CellAction    :@"onTouchVoiceCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                    AccessoryType : @(1),
                },
                @{
                    Title         :@"震动",
                    CellAction    :@"onTouchVibratCell:",
                    ShowAccessory : @(YES),
                    AccessoryType : @(1),
                },
            ],
            FooterTitle:@""
        },
    ];
    self.data = [JXCommonTableSection sectionsWithData:data];
}


#pragma mark - Action


- (void)onTouchNewMsgCell:(UISwitch *)switcher{
    NSLog(@"onTouchNewMsgCell");
}

- (void)onTouchMsgDetailCell:(UISwitch *)switcher{
    NIMPushNotificationSetting *setting = [NIMSDK sharedSDK].apnsManager.currentSetting;
    setting.type = switcher.on? NIMPushNotificationDisplayTypeDetail : NIMPushNotificationDisplayTypeNoDetail;
    [[NIMSDK sharedSDK].apnsManager updateApnsSetting:setting completion:^(NSError * _Nullable error) {
        if (error)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"设置失败,请重试"];
            switcher.on = !switcher.on;
        }
    }];
}

- (void)onTouchVoiceCell:(UISwitch *)switcher{

}

- (void)onTouchVibratCell:(UISwitch *)switcher{

}


@end
