//
//  JXSMSLoginViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/17.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXSMSLoginViewController.h"
#import "JXRegisterViewController.h"
#import "JXPwdLoginViewController.h"
#import "JXUserDataManager.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "RegisterSMSCodeData.h"
#import "SVProgressHUD.h"
#import "RequestLoginSMSCode.h"
#import "RequestSMSLogin.h"
#import "JXPerfectInfomation.h"
#import "JXMainTBC.h"
#import "JXLoginData.h"
#import <NIMSDK/NIMSDK.h>

@interface JXSMSLoginViewController ()

@property(nonatomic,strong) UILabel *lblTitle;
@property(nonatomic,strong) UILabel *lblRegion;
@property(nonatomic,strong) UILabel *lblErrMsg;
@property(nonatomic,strong) UILabel *lblCountDown;

@property(nonatomic,strong) UITextField *txtPhone;
@property(nonatomic,strong) UITextField *txtSMSCode;

@property(nonatomic,strong) UIButton *btnGetSMSCode;
@property(nonatomic,strong) UIButton *btnLogin;
@property(nonatomic,strong) UIButton *btnPwdLogin;
@property(nonatomic,strong) UIButton *btnMore;

@property(nonatomic,strong) RegisterSMSCodeData *sms;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger countDown;
@property(nonatomic,strong) NSDate *enterBackgroundTime;

@end

@implementation JXSMSLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"";
    self.view.backgroundColor = [UIColor background_white];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegister)];
    
    //创建ui
    [self.view addSubview:self.lblTitle];
    [self.view addSubview:self.lblRegion];
    [self.view addSubview:self.txtPhone];
    [self.view addSubview:self.txtSMSCode];
    [self.view addSubview:self.lblCountDown];
    [self.view addSubview:self.lblErrMsg];
    [self.view addSubview:self.btnGetSMSCode];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnPwdLogin];
    [self.view addSubview:self.btnMore];
    
    //创建ui约束
    [self addMasconstraint];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackGround) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeGround) name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"";
    [self clean];
    [self stopCountdown];
    [self.txtPhone becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopCountdown];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)didEnterBackGround{
    if (_timer && _countDown > 0) {
        _enterBackgroundTime = [NSDate date];
    }
}

- (void)willEnterForeGround{
    if (_timer && _countDown > 0 && _enterBackgroundTime) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_enterBackgroundTime];
        if (time > _countDown) {
            [self stopCountdown];
        }
        else
        {
            _countDown -= (NSInteger)time;
            self.lblCountDown.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)_countDown];
        }
    }
}

-(void)clean
{
    self.txtPhone.text = @"";
    self.txtSMSCode.text = @"";
    self.lblErrMsg.text = @"";
}

-(void) addMasconstraint
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        if (IOS_13) {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        } else {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_LT13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        }
    }];
    
    UILine_Block;
    
    [self.lblRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(self.lblTitle.mas_bottom).mas_equalTo(40);
    }];
    
    UIView *line_1 = createLine();
    [self.view addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lblRegion.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.view).mas_offset(-EDGE_LINE * 2);
        make.height.mas_equalTo(1);
    }];
    
    [self.txtPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(line_1.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(line_1);
    }];
    
    UIView *line_2 = createLine();
    [self.view addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtPhone.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(line_1);
    }];
    
    [self.btnGetSMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-EDGE_LINE);
        make.top.mas_equalTo(line_2.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(120);
    }];
    [self.lblCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.and.width.and.height.mas_equalTo(self.btnGetSMSCode);
    }];
    
    [self.txtSMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(line_2.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(self.btnGetSMSCode.mas_left).mas_equalTo(-15);
    }];
    
    UIView *line_3 = createLine();
    [self.view addSubview:line_3];
    [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtSMSCode.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(line_1);
    }];
    
    [self.lblErrMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_3.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_3.mas_bottom).mas_equalTo(40);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(40);
    }];
    
    [self.btnPwdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnLogin.mas_bottom).mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
    }];
}

-(void)showErrorMsg:(NSString *)errMsg
{
    self.lblErrMsg.text = errMsg;
}

/*
 * 登录
 */
-(void) onLogin
{
    if (!_sms || ![_sms isValid]) {
        [self showErrorMsg:@"请先获取验证码"];
        return;
    }
    
    if (_txtSMSCode.text.length < 1) {
        [self showErrorMsg:@"请输入正确的验证码"];
        return;
    }
    
    if (_txtSMSCode.text != _sms.code) {
        [self showErrorMsg:@"验证码错误"];
        return;
    }
    
    [SVProgressHUD show];
    RequestSMSLogin *api = [[RequestSMSLogin alloc] initWithSMSCode:self.sms.code CodeId:self.sms.codeId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        [SVProgressHUD dismiss];
        NSString *err = api.respMsg;
        if (0 == api.respStatus) {
            
            PerfectDatumData *perfectDatumData = [api perfectDatumData];
            if (perfectDatumData && perfectDatumData.isValid) {
                JXPerfectInfomation *perfectInfo = [[JXPerfectInfomation alloc] initWithPerfectDatumData:perfectDatumData];
                [self.navigationController pushViewController:perfectInfo animated:YES];
                return;
            }
            
            JIMAccount *account = [api jimAccount];
            if (account && account.isValid) {
                JXUserDataManager.sharedInstance.userData = account;
                [self nimManualLogin];
                ShowMainViewController;
                return;
            }
            
            err = @"登录失败，请重试";
        }
        self.txtSMSCode.text = @"";
        [SVProgressHUD showErrorWithStatus:err];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"登录失败，请重试"];
        
    }];
}

-(void)nimManualLogin
{
    JXLoginData *data = [JXUserDataManager.sharedInstance loginData];
    [[[NIMSDK sharedSDK] loginManager] login:data.nimAccount
                                       token:data.nimToken
                                  completion:^(NSError *error) {
        if (error)
        {
            NSLog(@"%@",error);
        }
    }];
}

-(void) onRegister
{
    [self.navigationController pushViewController:[JXRegisterViewController new] animated:YES];
}

/*
 * 密码登录
 */
-(void) onPwdLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * 获取验证码
 */
-(void) onGetSMSCode
{
    if (11 != _txtPhone.text.length) {
        [self showErrorMsg:@"请输入正确的手机号码"];
        return;
    }

    self.sms = nil;
    [SVProgressHUD show];
    RequestLoginSMSCode *api = [[RequestLoginSMSCode alloc] initWithPhone:_txtPhone.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"成功获取验证码返回");
        [SVProgressHUD dismiss];
        NSString *err = api.respMsg;
        if (0 == api.respStatus) {
            self.sms = [api codeData];
            if (self.sms) {
                NSLog(@"codeId:%@ | code:%@",self.sms.codeId,self.sms.code);
                [self showErrorMsg:[NSString stringWithFormat:@"code:%@",self.sms.code]];
                [self startCountdown];
                [self.txtSMSCode becomeFirstResponder];
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                return;
            }
            err = @"验证码获取失败，请重试";
        }
        [SVProgressHUD showErrorWithStatus:err];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"失败获取验证码返回");
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"验证码获取失败，请重试"];
        
    }];
}

/*
 * 更多
 */
-(void) onMore
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:nil];
    WEAK_SELF;
    UIAlertAction* regAccount = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [weakSelf.navigationController pushViewController:[JXRegisterViewController new] animated:YES];
                                                         }];
    
    UIAlertAction* smsLogin = [UIAlertAction actionWithTitle:@"密码登录" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [weakSelf.navigationController popViewControllerAnimated:YES];
                                                         }];
    [alert addAction:regAccount];
    [alert addAction:smsLogin];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)startCountdown
{
    self.btnGetSMSCode.hidden = YES;
    self.lblCountDown.hidden = NO;
    self.countDown = 90;
    self.lblCountDown.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)_countDown];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)stopCountdown
{
    self.btnGetSMSCode.hidden = NO;
    self.lblCountDown.hidden = YES;
    self.sms = nil;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)timerTick
{
    --_countDown;
    if (_countDown <= 0) {
        [self stopCountdown];
    }
    else
    {
        self.lblCountDown.text = [NSString stringWithFormat:@"重新获取(%ld)",(long)_countDown];
    }
}

#pragma mark - uicontroller

-(UILabel *)lblTitle
{
    if(!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont loginRegister_title];
        _lblTitle.text = @"短信验证码登录";
    }
    return _lblTitle;
}

-(UILabel *)lblRegion
{
    if(!_lblRegion)
    {
        _lblRegion = [[UILabel alloc] init];
        _lblRegion.font = [UIFont loginRegister_region];
        _lblRegion.text = @"中国(China)(+86)";
    }
    return _lblRegion;
}

-(UILabel *)lblErrMsg
{
    if(!_lblErrMsg)
    {
        _lblErrMsg = [[UILabel alloc] init];
        _lblErrMsg.font = [UIFont loginRegister_tipmsg];
        _lblErrMsg.textColor = [UIColor text_tip_error];
    }
    return _lblErrMsg;
}

-(UITextField *)txtPhone
{
    if (!_txtPhone) {
        _txtPhone = [[UITextField alloc] init];
        _txtPhone.placeholder = @"手机号码";
        _txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtPhone.keyboardType = UIKeyboardTypePhonePad;
        
        if (nil != [JXUserDataManager sharedInstance].userData && [JXUserDataManager sharedInstance].userData.jim_phone.length > 0) {
            _txtPhone.text = [JXUserDataManager sharedInstance].userData.jim_phone;
        }
    }
    return _txtPhone;
}

-(UILabel *)lblCountDown
{
    if(!_lblCountDown)
    {
        _lblCountDown = [[UILabel alloc] init];
        _lblCountDown.backgroundColor = RGBColor(230, 230, 230);
        _lblCountDown.textColor = [UIColor whiteColor];
        _lblCountDown.textAlignment = NSTextAlignmentCenter;
        [_lblCountDown.layer setMasksToBounds:YES];
        [_lblCountDown.layer setCornerRadius:5.0f];
    }
    return _lblCountDown;
}

-(UITextField *)txtSMSCode
{
    if(!_txtSMSCode)
    {
        _txtSMSCode = [[UITextField alloc] init];
        _txtSMSCode.placeholder = @"验证码";
        _txtSMSCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtSMSCode.keyboardType = UIKeyboardTypeNumberPad;
        _txtSMSCode.delegate = self;
    }
    return _txtSMSCode;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.txtSMSCode) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.txtSMSCode.text.length >= 6) {
            self.txtSMSCode.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}

-(UIButton *)btnGetSMSCode
{
    if(!_btnGetSMSCode)
    {
        _btnGetSMSCode = [[UIButton alloc] init];
        [_btnGetSMSCode.layer setMasksToBounds:YES];
        [_btnGetSMSCode.layer setCornerRadius:5.0f];
        [_btnGetSMSCode.titleLabel setFont:[UIFont loginRegister_smsCode]];
        [_btnGetSMSCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnGetSMSCode.backgroundColor = [UIColor buttonbg_register];
        [_btnGetSMSCode addTarget:self action:@selector(onGetSMSCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetSMSCode;
}

- (UIButton *)btnLogin
{
    if (!_btnLogin) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_loginButton]];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor buttonbg_login];
        [button addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
        _btnLogin = button;
    }
    return _btnLogin;
}

-(UIButton *)btnPwdLogin
{
    if (!_btnPwdLogin) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"使用密码登录" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont loginRegister_otherLoginButton]];
        [button setTitleColor:[UIColor text_whitebg_blue_light] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onPwdLogin) forControlEvents:UIControlEventTouchUpInside];
        _btnPwdLogin = button;
    }
    return _btnPwdLogin;
}

-(UIButton *)btnMore
{
    if(!_btnMore)
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [button setTitleColor:[UIColor text_whitebg_grey] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onMore) forControlEvents:UIControlEventTouchUpInside];
        _btnMore = button;
    }
    return _btnMore;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
