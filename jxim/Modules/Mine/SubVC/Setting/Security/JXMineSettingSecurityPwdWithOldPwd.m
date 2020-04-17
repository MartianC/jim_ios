//
//  JXMineSettingSecurityPwdWithOldPwd.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingSecurityPwdWithOldPwd.h"
#import "JXUserDataManager.h"
#import "Masonry.h"
#import "JXMineDef.h"
#import "UIColor+ColorExt.h"
#import <SVProgressHUD.h>
#import "UIFont+FontExt.h"
#import "UITableViewCell+CellExt.h"
#import <SVProgressHUD.h>
#import "RequestModifyLoginPwd.h"

@interface JXMineSettingSecurityPwdWithOldPwd ()

@property (nonatomic,strong) JIMAccount *user;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel     *lbl_hint;
@property (nonatomic,strong) UITextField *txf_oldPwd;
@property (nonatomic,strong) UITextField *txf_pwd;
@property (nonatomic,strong) UITextField *txf_pwdRepeat;

@property(nonatomic,strong) UIButton *btn_submitPwd;

@end

@implementation JXMineSettingSecurityPwdWithOldPwd

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"更改密码";
}

- (void)loadData{
    _user = JX_UserDataManager.userData;
}

- (void)loadUI{
    [self.view addSubview:[self getTable]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(0);
    }];
    
}

#pragma mark - Action

//更改密码
- (void)onSubmitPwd{
    [SVProgressHUD dismiss];
    if (_txf_pwd.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码必须大于6位"];
        return;
    }
    if (![_txf_pwd.text isEqualToString:_txf_pwdRepeat.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }

    RequestModifyLoginPwd *api = [[RequestModifyLoginPwd alloc] initWithJimId:self.user.jim_uniqueid OldPwd:_txf_oldPwd.text NewPwd:_txf_pwd.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@", api.respData);
        NSLog(@"%ld", (long)api.respStatus);
        if (0 == api.respStatus) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [SVProgressHUD showErrorWithStatus:@"设置密码失败，请重试"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD showErrorWithStatus:@"设置密码失败，请重试"];
    }];
}


#pragma mark - 获取元素

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
        //[self.tableView setScrollEnabled:NO];

        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }

    return self.tableView;
}

- (UILabel *)lblHint{
    if (!_lbl_hint) {
        _lbl_hint = [UILabel new];
        [_lbl_hint setFont:[UIFont systemFontOfSize:SmallFontSize]];
        [_lbl_hint setTextColor:[UIColor systemGrayColor]];
        [_lbl_hint setText:@"密码必须大于6位"];
        [_lbl_hint sizeToFit];
    }
    return _lbl_hint;
}

- (UITextField *)txfOldPwd
{
    if (!_txf_oldPwd) {
        _txf_oldPwd = [[UITextField alloc] init];
        _txf_oldPwd.placeholder = @"请输入原密码";
        _txf_oldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_oldPwd.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _txf_oldPwd;
}

- (UITextField *)txfPwd
{
    if (!_txf_pwd) {
        _txf_pwd = [[UITextField alloc] init];
        _txf_pwd.placeholder = @"请输入新密码";
        _txf_pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_pwd.secureTextEntry = YES;
    }
    return _txf_pwd;
}

- (UITextField *)txfPwdRepeat
{
    if (!_txf_pwdRepeat) {
        _txf_pwdRepeat = [[UITextField alloc] init];
        _txf_pwdRepeat.placeholder = @"请再次输入新密码";
        _txf_pwdRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_pwdRepeat.secureTextEntry = YES;
    }
    return _txf_pwdRepeat;
}

- (UIButton *)btnSubmitPwd
{
    if (!_btn_submitPwd) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_registerButton]];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor systemBlueColor];
        [button addTarget:self action:@selector(onSubmitPwd) forControlEvents:UIControlEventTouchUpInside];
        _btn_submitPwd = button;
    }
    return _btn_submitPwd;
}


#pragma mark - SetCell


- (void)setCell_oldPwd: (UITableViewCell *)cell{
    cell.textLabel.text = @"原密码";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self txfOldPwd]];
    //分隔线
    [cell createBottomLineWithHeight:1 left:0 right:0];
    [cell bottomLineLeftToTextlabel];
    
    [self.txf_oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}

- (void)setCell_pwd: (UITableViewCell *)cell{
    cell.textLabel.text = @"新密码";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self txfPwd]];
    //分隔线
    [cell createBottomLineWithHeight:1 left:0 right:0];
    [cell bottomLineLeftToTextlabel];
    
    [self.txf_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}

- (void)setCell_pwdRepeat: (UITableViewCell *)cell{
    cell.textLabel.text = @"确认密码";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self txfPwdRepeat]];
    
    [self.txf_pwdRepeat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
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
    return 100.f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.item) {
        case 0:
            [self setCell_oldPwd:cell];
            break;
        case 1:
            [self setCell_pwd:cell];
            break;
        case 2:
            [self setCell_pwdRepeat:cell];
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    //UIView *footer = [UIView new];
    [footer addSubview:[self lblHint]];
    [footer addSubview:[self btnSubmitPwd]];
    
    [_lbl_hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(footer).with.offset(OffsetSize);
    }];
    [_btn_submitPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lbl_hint.mas_bottom).with.offset(OffsetSize);
        make.height.mas_equalTo(BigButtonHeight);
        make.left.mas_equalTo(footer).with.offset(OffsetSize_Big);
        make.right.mas_equalTo(footer).with.offset(-OffsetSize_Big);
    }];
    
    return footer;
}


@end
