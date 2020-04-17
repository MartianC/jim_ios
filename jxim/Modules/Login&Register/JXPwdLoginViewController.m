//
//  JXPwdLoginViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/17.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXPwdLoginViewController.h"
#import "JXRegisterViewController.h"
#import "JXSMSLoginViewController.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"
#import "SVProgressHUD.h"
#import "RequestPerfectDatum.h"
#import "JXUserDataManager.h"
#import "JXMainTBC.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "RequestPasswordLogin.h"
#import "JIMAccount.h"
#import "JXLoginData.h"
#import <NIMSDK/NIMSDK.h>

@interface JXPwdLoginViewController ()

@property(nonatomic,strong) UILabel *lblTitle;
@property(nonatomic,strong) UILabel *lblRegion;
@property(nonatomic,strong) UILabel *lblErrMsg;

@property(nonatomic,strong) UITextField *txtPhone;
@property(nonatomic,strong) UITextField *txtPwd;

@property(nonatomic,strong) UIButton *btnLogin;
@property(nonatomic,strong) UIButton *btnSMSLogin;
@property(nonatomic,strong) UIButton *btnMore;

@end

@implementation JXPwdLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"";
    self.view.backgroundColor = [UIColor background_white];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegister)];
    
    //创建ui
    [self.view addSubview:self.lblTitle];
    [self.view addSubview:self.lblRegion];
    [self.view addSubview:self.txtPhone];
    [self.view addSubview:self.txtPwd];
    [self.view addSubview:self.lblErrMsg];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnSMSLogin];
    [self.view addSubview:self.btnMore];
    
    //创建ui约束
    [self addMasconstraint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"";
    [self clean];
    [self.txtPhone becomeFirstResponder];
}

-(void)clean
{
    self.txtPhone.text = @"";
    self.txtPwd.text = @"";
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
    
    [self.txtPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(line_2.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(line_2);
    }];
    
    UIView *line_3 = createLine();
    [self.view addSubview:line_3];
    [line_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtPwd.mas_bottom).mas_equalTo(10);
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
    
    [self.btnSMSLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnLogin.mas_bottom).mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
    }];
}

-(void)showErrMsg:(NSString *)errMsg
{
    self.lblErrMsg.text = errMsg;
}

/*
 * 登录
 */
-(void) onLogin
{
    if (11 != self.txtPhone.text.length) {
        [self showErrMsg:@"请输入正确的手机号"];
        return;
    }
    if (self.txtPwd.text.length < 6) {
        [self showErrMsg:@"请输入正确的密码"];
        return;
    }
    [self showErrMsg:@""];
    [SVProgressHUD show];
    
    RequestPasswordLogin *api = [[RequestPasswordLogin alloc] initWithPhone:self.txtPhone.text andPwd:self.txtPwd.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        NSString *err = api.respMsg;
        if (0 == api.respStatus) {
            
            JIMAccount *account = [api successData];
            if (account && account.isValid) {
                JXUserDataManager.sharedInstance.userData = account;
                [self nimManualLogin];
                ShowMainViewController;
                return;
            }
            err = @"登录失败，请重试";
        }
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

/*
 * 短信验证码登录
 */
-(void) onSMSLogin
{
    [self.navigationController pushViewController:[JXSMSLoginViewController new] animated:YES];
}

-(void) onRegister
{
    [self.navigationController pushViewController:[JXRegisterViewController new] animated:YES];
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
    UIAlertAction* regAccount = [UIAlertAction actionWithTitle:@"注册"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {

        [weakSelf.navigationController pushViewController:[JXRegisterViewController new] animated:YES];
        
    }];
    
    UIAlertAction* smsLogin = [UIAlertAction actionWithTitle:@"验证码登录"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
        
        [weakSelf.navigationController pushViewController:[JXSMSLoginViewController new] animated:YES];
        
    }];
    
    [alert addAction:regAccount];
    [alert addAction:smsLogin];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - uicontroller

-(UILabel *)lblTitle
{
    if(!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont loginRegister_title];
        _lblTitle.text = @"密码登录";
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
    }
    return _txtPhone;
}

-(UITextField *)txtPwd
{
    if(!_txtPwd)
    {
        _txtPwd = [[UITextField alloc] init];
        _txtPwd.placeholder = @"登录密码";
        _txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtPwd.secureTextEntry = YES;
    }
    return _txtPwd;
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

-(UIButton *)btnSMSLogin
{
    if (!_btnSMSLogin) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"使用短信验证码登录" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont loginRegister_otherLoginButton]];
        [button setTitleColor:[UIColor text_whitebg_blue_light] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onSMSLogin) forControlEvents:UIControlEventTouchUpInside];
        _btnSMSLogin = button;
    }
    return _btnSMSLogin;
}

-(UIButton *)btnMore
{
    if(!_btnMore)
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont loginRegister_more]];
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
