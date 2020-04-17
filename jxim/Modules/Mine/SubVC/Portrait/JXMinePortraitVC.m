//
//  JXMinePortraitVC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/2.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMinePortraitVC.h"
#import <NIMKit.h>
#import "JXUserDataManager.h"
#import "JXMinePortraitSettingVC.h"
#import "JXMinePortraitNicknameVC.h"
#import "RequestModifyGender.h"
#import <SVProgressHUD.h>

@implementation JXMinePortraitVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"个人资料";
}

- (void)loadData {
    JIMAccount *user = JXUserDataManager.sharedInstance.userData;
    
    NSArray *data = @[
        @{
            HeaderTitle  :@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent   :@[
                @{
                    Title         : @"头像",
                    CellClass     : @"JXMinePortraitCell",
                    RowHeight     : @(JXSettingAvatarCellHeight),
                    CellAction    : @"onTouchPortraitCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                    ExtraInfo     : user.jim_header,
                },
                @{
                    Title         : @"昵称",
                    DetailTitle   : user.jim_nickname.length ? user.jim_nickname : @"未设置",
                    CellAction    : @"onTouchNicknameCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"电话",
                    DetailTitle   : user.jim_phone.length ? user.jim_phone : @"未设置",
                    CellAction    : @"onTouchCell:",
                    //ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"游聊号",
                    DetailTitle   : user.jim_account,
                    CellAction    : @"onTouchCell:",
                    //ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"我的二维码",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"性别",
                    DetailTitle   :user.jim_gender == Gender_Male ? @"男" : @"女",
                    CellAction    :@"onTouchGenderCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                    //ShowRedDot    : @(YES),
                },
//                @{
//                    Title         :@"出生日期",
//                    DetailTitle   : @"未完善",
//                    CellAction    :@"onTouchCell:",
//                    ShowAccessory : @(YES),
//                    ShowRedDot    : @(YES),
//                },
            ],
            FooterTitle:@""
        },
    ];
    self.data = [JXCommonTableSection sectionsWithData:data];
}


#pragma mark - Action


- (void)onTouchPortraitCell:(id)sender{
    JXMinePortraitSettingVC *vc = [[JXMinePortraitSettingVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchNicknameCell:(id)sender{
    JXMinePortraitNicknameVC *vc = [[JXMinePortraitNicknameVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchGenderCell:(id)sender{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:nil];
    UIAlertAction* male = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
        [self onChangeGender:Gender_Male];
    }];
    UIAlertAction* female = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
        [self onChangeGender:Gender_Female];
    }];
    
    [alert addAction:male];
    [alert addAction:female];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onTouchCell:(id)sender{
    
}


#pragma mark - ChangeGender

- (void)onChangeGender: (NSUInteger)gender{
    if (gender != Gender_Male && gender != Gender_Female) {
        return;
    }
    JIMAccount *user = JX_UserDataManager.userData;
    RequestModifyGender *api = [[RequestModifyGender alloc] initWithJimId:user.jim_uniqueid Gender:gender];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        user.jim_gender = gender;
        [self loadData];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"修改失败,请重试"];
    }];
}

@end
