//
//  JXFastLoginViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/18.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXFastLoginViewController.h"
#import "JXPwdLoginViewController.h"
#import "JXRegisterViewController.h"
#import "JXUserDataManager.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"
#import "SDWebImage.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "RequestPasswordLogin.h"
#import "SVProgressHUD.h"
#import "JXMainTBC.h"
#import "JXLoginData.h"
#import <NIMSDK/NIMSDK.h>

@interface JXFastLoginViewController ()

@property(nonatomic,strong) UIImageView *imgHeader;
@property(nonatomic,strong) UILabel *lblPhone;
@property(nonatomic,strong) UILabel *lblErrMsg;

@property(nonatomic,strong) UITextField *txtPwd;

@property(nonatomic,strong) UIButton *btnLogin;
@property(nonatomic,strong) UIButton *btnMore;

@property(nonatomic,copy) NSString *phone;

@end

@implementation JXFastLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegister)];

    //创建ui
    [self.view addSubview:self.imgHeader];
    [self.view addSubview:self.lblPhone];
    [self.view addSubview:self.lblErrMsg];
    [self.view addSubview:self.txtPwd];
    [self.view addSubview:self.btnLogin];
    [self.view addSubview:self.btnMore];

    //创建ui约束
    [self addMasconstraint];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clean];
    [self.txtPwd becomeFirstResponder];
}

-(void)clean
{
    self.txtPwd.text = @"";
    self.lblErrMsg.text = @"";
}

-(void) addMasconstraint
{
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.width.and.height.mas_equalTo(100);
        
        if (IOS_13) {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        } else {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_LT13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        }
    }];
    
    self.imgHeader.layer.masksToBounds = YES;
    self.imgHeader.layer.cornerRadius = 50;
    
    UILine_Block;
    
    [self.lblPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgHeader.mas_bottom).mas_equalTo(20);
    }];
    
    [self.txtPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(self.lblPhone.mas_bottom).mas_equalTo(40);
        make.width.mas_equalTo(self.view).mas_offset(-EDGE_LINE * 2);
    }];
    
    UIView *line_1 = createLine();
    [self.view addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtPwd.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.txtPwd);
        make.height.mas_equalTo(1);
    }];
    
    [self.lblErrMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_1.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_1.mas_bottom).mas_equalTo(40);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(40);
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
    if (self.txtPwd.text.length < 6) {
        [self showErrMsg:@"请输入正确的密码"];
        return;
    }
    
    if (11 != self.phone.length) {
        [self showErrMsg:@"未知错误,请切换账号尝试"];
        return;
    }
    
    [self showErrMsg:@""];
    [SVProgressHUD show];
    
    RequestPasswordLogin *api = [[RequestPasswordLogin alloc] initWithPhone:self.phone andPwd:self.txtPwd.text];
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
    UIAlertAction* regAccount = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [weakSelf.navigationController pushViewController:[JXRegisterViewController new] animated:YES];
                                                         }];
    
    UIAlertAction* smsLogin = [UIAlertAction actionWithTitle:@"切换账号" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [weakSelf.navigationController pushViewController:[JXPwdLoginViewController new] animated:YES];
                                                         }];
    [alert addAction:regAccount];
    [alert addAction:smsLogin];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - uicontroller

-(UIImageView *)imgHeader
{
    if (!_imgHeader) {
        
        if (JX_UserDataManager.userData || JX_UserDataManager.userData.jim_header.length > 0) {
            _imgHeader = [[UIImageView alloc] init];
            NSURL *headUrl = [[NSURL alloc] initWithString:JX_UserDataManager.userData.jim_header];
            [_imgHeader sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"header_default"]];
        }
        else{
            _imgHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_default"]];
        }
    }
    return _imgHeader;
}

-(UILabel *)lblPhone
{
    if(!_lblPhone)
    {
        _lblPhone = [[UILabel alloc] init];
        _lblPhone.font = [UIFont loginRegister_phoneNum];
        
        if (nil != JX_UserDataManager.userData && 0 != JX_UserDataManager.userData.jim_phone.length) {
            _lblPhone.text = [@"+86 " stringByAppendingString: JX_UserDataManager.userData.jim_phone];
            self.phone = JX_UserDataManager.userData.jim_phone;
        }
        else
        {
            _lblPhone.text = @"";
            self.phone = @"";
        }
    }
    return _lblPhone;
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
