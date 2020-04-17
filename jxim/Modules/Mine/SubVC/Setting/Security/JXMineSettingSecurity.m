//
//  JXMineSettingSecurity.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingSecurity.h"
#import "JXUserDataManager.h"
#import "JXMineSettingSecurityPwdWithSms.h"
#import "JXMineSettingSecurityPwdWithOldPwd.h"
#import "JXMineSettingSecurityChangePhone.h"

@interface JXMineSettingSecurity ()

@property (nonatomic,strong) JIMAccount *user;

@end

@implementation JXMineSettingSecurity

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"安全";
}

- (void)loadData {
    self.user = JX_UserDataManager.userData;
    NSArray *data = @[
        @{
            HeaderTitle:@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent :@[
                @{
                    Title         :@"手机号",
                    DetailTitle   :self.user.jim_phone,
                    CellAction    :@"onTouchChangePhone:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         :@"设置登录密码",
                    DetailTitle   :@"",
                    CellAction    :@"onTouchSetPwdWithSMS:",
                    ShowAccessory :@(YES),
                    ShowRedDot    :@(YES),
                },
            ],
            FooterTitle:@""
        },
    ];
    if (self.user.status_loginpwd) {
        //设置过密码的情况
        data = @[
            @{
                HeaderTitle:@"",
                HeaderHeight :@SectionHeaderHeight,
                RowContent :@[
                    @{
                        Title         :@"手机号",
                        DetailTitle   :self.user.jim_phone,
                        CellAction    :@"onTouchChangePhone:",
                        ShowAccessory : @(YES),
                        ShowBottomLine : @(YES),
                    },
                    @{
                        Title         :@"设置登录密码",
                        DetailTitle   :@"",
                        CellAction    :@"onTouchSetPwdWithOldPwd:",
                        ShowAccessory :@(YES),
                        ShowBottomLine : @(YES),
                    },
                    @{
                        Title         :@"忘记登录密码",
                        DetailTitle   :@"",
                        CellAction    :@"onTouchSetPwdWithSMS:",
                        ShowAccessory :@(YES),
                    },
                ],
                FooterTitle:@""
            },
        ];
    }
    self.data = [JXCommonTableSection sectionsWithData:data];
}


#pragma mark - Action


- (void)onTouchSetPwdWithSMS:(id)sender{
    JXMineSettingSecurityPwdWithSms *vc = [[JXMineSettingSecurityPwdWithSms alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchSetPwdWithOldPwd:(id)sender{
    JXMineSettingSecurityPwdWithOldPwd *vc = [[JXMineSettingSecurityPwdWithOldPwd alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchChangePhone:(id)sender{
    JXMineSettingSecurityChangePhone *vc = [[JXMineSettingSecurityChangePhone alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
