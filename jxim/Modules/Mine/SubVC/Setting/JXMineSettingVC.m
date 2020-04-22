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
#import "JXAccountDetailDatum.h"
#import <NIMKit.h>
#import "UIAlertView+JXBlock.h"
#import <SVProgressHUD.h>
#import "JXMineSettingAbout.h"

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
                    CellAction    : @"onTouchCleanCacheCell:",
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
                    CellAction    :@"onTouchAboutCell:",
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
                    CellAction    :@"onTouchLogoutCell:",
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

- (void)onTouchLogoutCell:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"退出当前帐号？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
        switch (alertIndex) {
            case 1:
                [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
                 {
                     extern NSString *JXNotificationLogout;
                     [[NSNotificationCenter defaultCenter] postNotificationName:JXNotificationLogout object:nil];
                 }];
                break;
            default:
                break;
        }
    }];
}

- (void)onTouchCleanCacheCell:(id)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"清除后，图片、视频等多媒体消息需要重新下载查看。确定清除？" preferredStyle:UIAlertControllerStyleActionSheet];
    [[vc addAction:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NIMResourceQueryOption *option = [[NIMResourceQueryOption alloc] init];
        option.timeInterval = 0;
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].resourceManager removeResourceFiles:option completion:^(NSError * _Nullable error, long long freeBytes) {
            [SVProgressHUD dismiss];
            if (error)
            {
                UIAlertController *result = [UIAlertController alertControllerWithTitle:@"" message:@"清除失败！" preferredStyle:UIAlertControllerStyleAlert];
                [result addAction:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [result show];
            }
            else
            {
                CGFloat freeMB = (CGFloat)freeBytes / 1000 / 1000;
                UIAlertController *result = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"成功清理了%.2fMB磁盘空间",freeMB] preferredStyle:UIAlertControllerStyleAlert];
                [result addAction:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [result show];
            }
        }];
    }]
     addAction:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [vc show];
}

- (void)onTouchAboutCell:(id)sender{
    JXMineSettingAbout *vc = [[JXMineSettingAbout alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchCell:(id)sender{
//    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
//    JXAccountDetailDatum *vc = [[JXAccountDetailDatum alloc] initWithNIMAccId: uid];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
