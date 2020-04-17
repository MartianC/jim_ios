//
//  JXRegisterViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/17.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXRegisterViewController.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"
#import "UIImageView+WebCache.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "SVProgressHUD.h"
#import "RequestRegisterSMSCode.h"
#import "RegisterByPhone.h"
#import "JXPerfectInfomation.h"
#import "UIView+Toast.h"
#import "PerfectDatumData.h"


@interface JXRegisterViewController ()

@property(nonatomic,strong) UILabel *lblTitle;
@property(nonatomic,strong) UILabel *lblRegion;
@property(nonatomic,strong) UILabel *lblErrMsg;

@property(nonatomic,strong) UITextField *txtPhone;
@property(nonatomic,strong) UITextField *txtSMSCode;

@property(nonatomic,strong) UIButton *btnGetSMSCode;
@property(nonatomic,strong) UIButton *btnRegister;
@property(nonatomic,strong) UILabel *lblCountDown;

@property(nonatomic,strong) RegisterSMSCodeData *sms;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger countDown;
@property(nonatomic,strong) NSDate *enterBackgroundTime;

@end

@implementation JXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建ui
    [self.view addSubview:self.lblTitle];
    [self.view addSubview:self.lblRegion];
    [self.view addSubview:self.txtPhone];
    [self.view addSubview:self.txtSMSCode];
    [self.view addSubview:self.btnGetSMSCode];
    [self.view addSubview:self.lblErrMsg];
    [self.view addSubview:self.btnRegister];
    [self.view addSubview:self.lblCountDown];
    self.lblCountDown.hidden = YES;
    
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
    
    [self stopCountdown];
    [self clean];
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
    
    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_3.mas_bottom).mas_equalTo(40);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(40);
    }];
}

-(void)clean
{
    _txtPhone.text = @"";
    _txtSMSCode.text = @"";
}

-(void)showErrorMsg:(NSString *)errmsg
{
    if ([NSString isNulOrEmpty:errmsg])return;
    self.lblErrMsg.text = errmsg;
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

/*
 * 注册
 */
-(void) onRegister
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
    RegisterByPhone *api = [[RegisterByPhone alloc] initWithSMSCode:_sms.code CodeId:_sms.codeId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        NSString *err = api.respMsg;
        if (0 == api.respStatus) {
            PerfectDatumData *result = [api resultData];
            if (result) {
                JXPerfectInfomation *perfectInfo = [[JXPerfectInfomation alloc] initWithPerfectDatumData:result];
                [self.navigationController pushViewController:perfectInfo animated:YES];
                return;
            }
            err = @"注册失败，请重试";
        }
        self.txtSMSCode.text = @"";
        [SVProgressHUD showErrorWithStatus:err];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"注册失败，请重试"];
        
    }];
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
    RequestRegisterSMSCode *api = [[RequestRegisterSMSCode alloc] initWithPhone:_txtPhone.text];
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

#pragma mark - uicontroller

-(UILabel *)lblTitle
{
    if(!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont loginRegister_title];
        _lblTitle.text = @"注册游聊";
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

-(UITextField *)txtPhone
{
    if (!_txtPhone) {
        _txtPhone = [[UITextField alloc] init];
        _txtPhone.placeholder = @"手机号码";
        _txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtPhone.keyboardType = UIKeyboardTypePhonePad;
    }
    return _txtPhone;
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

- (UIButton *)btnRegister
{
    if (!_btnRegister) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_registerButton]];
        [button setTitle:@"注册" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor buttonbg_register];
        [button addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
        _btnRegister = button;
    }
    return _btnRegister;
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
