//
//  JXMineSubViewController.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/2.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingVC.h"
#import "JXUserDataManager.h"
#import "JXMineSettingSecurity.h"
#import "JXMineSettingNotification.h"

@implementation JXMineSettingVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置";
}

- (void)loadData {
    JIMAccount *user = JX_UserDataManager.userData;
    NSArray *data = @[
        @{
            HeaderTitle  :@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent   :@[
                @{
                    Title         : @"安全",
                    CellAction    : @"onTouchSecurityCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                    ShowRedDot    : user.status_loginpwd ? @(NO) : @(YES),
                },
                @{
                    Title         : @"绑定微信",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         : @"新消息通知",
                    CellAction    : @"onTouchNotificationCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"隐私",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"清除缓存",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"通用",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"关于",
                    CellAction    :@"onTouchCell:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"退出登录",
                    CellClass     : @"JXMineSignOutCell",
                    CellAction    :@"onTouchCell:",
                    ShowAccessory : @(NO)
                },
            ],
            FooterTitle:@""
        },
    ];
    self.data = [JXCommonTableSection sectionsWithData:data];
}

+ (BOOL)willShowRedDot{
    JIMAccount *user = JX_UserDataManager.userData;
    return !user.status_loginpwd;
}

#pragma mark - Action

- (void)onTouchSecurityCell:(id)sender{
    JXMineSettingSecurity *vc = [[JXMineSettingSecurity alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchNotificationCell:(id)sender{
    JXMineSettingNotification *vc = [[JXMineSettingNotification alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchCell:(id)sender{
    
}

@end
