//
//  JXMinePortraitNicknameVC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMinePortraitNicknameVC.h"
#import "JXUserDataManager.h"
#import "Masonry.h"
#import "JXMineDef.h"
#import "UIColor+ColorExt.h"
#import "RequestModifyNickname.h"
#import <SVProgressHUD.h>
#import <NIMKit.h>

@interface JXMinePortraitNicknameVC ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *txf_name;

@end

@implementation JXMinePortraitNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"设置昵称";
    //背景
    //[self.view setBackgroundColor:[UIColor clearColor]];
}

- (void) loadUI{
    //导航栏定制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onChangeNickname)];

    [self.view addSubview:[self getTable]];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
//    [self.txf_name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.and.top.and.bottom.mas_equalTo(self.txf_name.superview);
//        make.left.mas_equalTo(self.txf_name.superview.left).with.offset(OffsetSize);
//    }];
}

- (UITableView *)getTable{
    if (!self.tableView) {
         self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //段落背景
        //[self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        //段落标题颜色
        [self.tableView setSectionIndexColor:[UIColor text_greybg_darkgrey]];
        //去除tableView默认的分割线
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //禁止滑动
        [self.tableView setScrollEnabled:NO];

        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }

    return self.tableView;
}


- (void)onChangeNickname{
    if (!self.txf_name.text.length) {
        return;
    }
    [SVProgressHUD show];
    JIMAccount *user = JX_UserDataManager.userData;
    NSString *newNickname = self.txf_name.text;
    RequestModifyNickname * api = [[RequestModifyNickname alloc] initWithJimId:user.jim_uniqueid Nickname:newNickname];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (0 == api.respStatus) {
            //更新成功
            [self updateToNIM];
            return;
        }
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"更改昵称失败,请重试"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"更改昵称失败,请重试"];
    }];
}

- (void)updateToNIM{
    NSString *newNickname = self.txf_name.text;
    if (!newNickname.length) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    if (newNickname.length > 13) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"昵称过长"];
        return;
    }
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagNick) : newNickname} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            //更新成功
            [SVProgressHUD dismiss];
            JX_UserDataManager.userData.jim_nickname = newNickname;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"更改昵称失败,请重试"];
        }
    }];
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JXUIRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JIMAccount *user = JX_UserDataManager.userData;
    self.txf_name = [[UITextField alloc] initWithFrame:cell.bounds];
    [self.txf_name setFont: [UIFont systemFontOfSize:NameFontSize]];
    [self.txf_name setText:user.jim_nickname];
    [self.txf_name setPlaceholder:@"请输入您的昵称"];
    [cell addSubview:self.txf_name];

    [self.txf_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.mas_equalTo(cell);
        make.left.mas_equalTo(cell).with.offset(OffsetSize);
    }];
    
    return cell;
}
@end
