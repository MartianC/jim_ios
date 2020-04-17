//
//  JXMineSettingSecurityPwdWithSms.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingSecurityPwdWithSms.h"
#import "JXUserDataManager.h"
#import "Masonry.h"
#import "JXMineDef.h"
#import "UIColor+ColorExt.h"
#import <SVProgressHUD.h>
#import "UIFont+FontExt.h"
#import "UITableViewCell+CellExt.h"
#import <SVProgressHUD.h>
#import "RequestGetSMSCode.h"
#import "RequestSetInitLoginPwd.h"
#import "RequestResetLoginPwd.h"

@class JIMAccount;

@interface JXMineSettingSecurityPwdWithSms ()

@property (nonatomic,strong) JIMAccount *user;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel     *lbl_hint;
@property (nonatomic,strong) UILabel     *lbl_phone;
@property (nonatomic,strong) UITextField *txf_smsCode;
@property (nonatomic,strong) UITextField *txf_pwd;
@property (nonatomic,strong) UITextField *txf_pwdRepeat;

@property(nonatomic,strong) UIButton *btn_GetSMSCode;
@property(nonatomic,strong) UIButton *btn_submitPwd;

@property(nonatomic,strong) RegisterSMSCodeData *sms;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger countDown;
@property(nonatomic,strong) NSDate *enterBackgroundTime;

@end

@implementation JXMineSettingSecurityPwdWithSms

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.user.status_loginpwd) {
        self.navigationItem.title = @"重置密码";
    }
    else {
        self.navigationItem.title = @"设置初始密码";
    }
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

//获取验证码
- (void)onGetSMSCode{
    RequestGetSMSCode *api = [[RequestGetSMSCode alloc] initWithJimId:self.user.jim_uniqueid Phone:self.user.jim_phone];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSString *err = api.respMsg;
        NSLog(@"%@", api.respData);
        if (0 == api.respStatus) {
            self.sms = [api codeData];
            if (self.sms) {
                NSLog(@"codeId:%@ | code:%@",self.sms.codeId,self.sms.code);
                [self.lbl_hint setText:[NSString stringWithFormat:@"code:%@",self.sms.code]];
                [self startCountdown];
                [self.txf_smsCode becomeFirstResponder];
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                return;
            }
            err = @"验证码获取失败，请重试";
        }
        [SVProgressHUD showErrorWithStatus:err];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"验证码获取失败，请重试"];
    }];
}

//更改密码
- (void)onSubmitPwd{
    [SVProgressHUD dismiss];
    if (_txf_smsCode.text != _sms.code) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    if (_txf_pwd.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码必须大于6位"];
        return;
    }
    if (![_txf_pwd.text isEqualToString:_txf_pwdRepeat.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }

    if(!self.user.status_loginpwd){
        //设置初始密码
        RequestSetInitLoginPwd *api = [[RequestSetInitLoginPwd alloc] initWithJimId:self.user.jim_uniqueid Pwd:self.txf_pwd.text Code:self.sms.code CodeId:self.sms.codeId];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (0 == api.respStatus) {
                self.user.status_loginpwd = 1;
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"设置密码失败，请重试"];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD showErrorWithStatus:@"设置密码失败，请重试"];
        }];
    }
    else{
        //忘记密码
        RequestResetLoginPwd *api = [[RequestResetLoginPwd alloc] initWithJimId:self.user.jim_uniqueid Pwd:self.txf_pwd.text Code:self.sms.code CodeId:self.sms.codeId];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (0 == api.respStatus) {
                [SVProgressHUD showSuccessWithStatus:@"重置成功"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"重置密码失败，请重试"];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD showErrorWithStatus:@"重置密码失败，请重试"];
        }];
    }
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

- (UILabel *)lblPhone{
    if (!_lbl_phone) {
        _lbl_phone = [UILabel new];
        [_lbl_phone setFont:[UIFont systemFontOfSize:InputeFontSize]];
        [_lbl_phone setText:_user.jim_phone];
    }
    return _lbl_phone;
}

- (UITextField *)txfSMSCode
{
    if (!_txf_smsCode) {
        _txf_smsCode = [[UITextField alloc] init];
        _txf_smsCode.placeholder = @"请输入短信验证码";
        _txf_smsCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_smsCode.keyboardType = UIKeyboardTypeNumberPad;
        _txf_smsCode.delegate = self;
    }
    return _txf_smsCode;
}

- (UITextField *)txfPwd
{
    if (!_txf_pwd) {
        _txf_pwd = [[UITextField alloc] init];
        _txf_pwd.placeholder = @"请输入登录密码";
        _txf_pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_pwd.secureTextEntry = YES;
    }
    return _txf_pwd;
}

- (UITextField *)txfPwdRepeat
{
    if (!_txf_pwdRepeat) {
        _txf_pwdRepeat = [[UITextField alloc] init];
        _txf_pwdRepeat.placeholder = @"请再次输入登录密码";
        _txf_pwdRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txf_pwdRepeat.secureTextEntry = YES;
    }
    return _txf_pwdRepeat;
}

-(UIButton *)btnGetSMSCode
{
    if(!_btn_GetSMSCode)
    {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_smsCode]];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor systemBlueColor];
        [button addTarget:self action:@selector(onGetSMSCode) forControlEvents:UIControlEventTouchUpInside];
        _btn_GetSMSCode = button;
    }
    return _btn_GetSMSCode;
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

- (void)setCell_areaCode: (UITableViewCell *)cell{
    cell.textLabel.text = @"中国(+86)";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //分隔线
    [cell createBottomLineWithHeight:1 left:0 right:0];
    [cell bottomLineLeftToTextlabel];
    
}

- (void)setCell_phone: (UITableViewCell *)cell{
    cell.textLabel.text = @"手机号码";
    [cell.textLabel sizeToFit];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self lblPhone]];
    //分隔线
    [cell createBottomLineWithHeight:1 left:0 right:0];
    [cell bottomLineLeftToTextlabel];
    
    [self.lbl_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}

- (void)setCell_smsCode: (UITableViewCell *)cell{
    cell.textLabel.text = @"验证码  ";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self txfSMSCode]];
    [cell addSubview:[self btnGetSMSCode]];
    //分隔线
    [cell createBottomLineWithHeight:1 left:0 right:0];
    [cell bottomLineLeftToTextlabel];
    
    [self.txf_smsCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
    [self.btn_GetSMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).with.offset(OffsetSize);
        make.bottom.mas_equalTo(cell.mas_bottom).with.offset(-OffsetSize);
        make.width.mas_equalTo(SMSCodeBtnWidth);
        make.right.mas_equalTo(cell.mas_right).with.offset(-OffsetSize);
    }];
}

- (void)setCell_pwd: (UITableViewCell *)cell{
    cell.textLabel.text = @"登录密码";
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.item) {
        case 0:
            [self setCell_areaCode:cell];
            break;
        case 1:
            [self setCell_phone:cell];
            break;
        case 2:
            [self setCell_smsCode:cell];
            break;
        case 3:
            [self setCell_pwd:cell];
            break;
        case 4:
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.txf_smsCode) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.txf_smsCode.text.length >= 6) {
            self.txf_smsCode.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}


#pragma mark - 其他

- (void)startCountdown
{
//    self.btnGetSMSCode.hidden = YES;
//    self.lblCountDown.hidden = NO;
    self.countDown = 90;
    [self.btn_GetSMSCode setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)_countDown] forState:UIControlStateNormal];
    [self.btn_GetSMSCode setEnabled:NO];
    [self.btn_GetSMSCode setBackgroundColor:[UIColor systemGrayColor]];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

- (void)stopCountdown
{
    [self.btn_GetSMSCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_GetSMSCode setEnabled:YES];
    [self.btn_GetSMSCode setBackgroundColor:[UIColor systemBlueColor]];
    self.sms = nil;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-  (void)timerTick
{
    --_countDown;
    if (_countDown <= 0) {
        [self stopCountdown];
    }
    else
    {
        [self.btn_GetSMSCode setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)_countDown] forState:UIControlStateNormal];
    }
}



@end
