//
//  JXPerfectInfomation.m
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXPerfectInfomation.h"
#import "UIColor+ColorExt.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "RequestPerfectDatum.h"
#import "JXUserDataManager.h"
#import "JXMainTBC.h"
#import "JXIMGlobalDef.h"
#import "NSString+StringExt.h"
#import "QNUploadManager.h"
#import "QNResponseInfo.h"
#import "JXMainStatusManager.h"
#import "JXLoginData.h"
#import <NIMSDK/NIMSDK.h>

@interface JXPerfectInfomation ()

@property(nonatomic,strong) UIImageView *imgHeader;
@property(nonatomic,strong) UIButton *btnSetHeader;
@property(nonatomic,strong) UITextField *txtNickName;
@property(nonatomic,strong) UIButton *btnMale;
@property(nonatomic,strong) UIButton *btnFemale;
@property(nonatomic,strong) UIButton *btnOk;
@property(nonatomic,strong) UIButton *btnLoginout;
@property(nonatomic,strong) UIImage *imgHeaderData;

@property(nonatomic,strong) PerfectDatumData *pefectDatumData;
@property(nonatomic,assign) NSUInteger gender;

@end

@implementation JXPerfectInfomation

-(instancetype)initWithPerfectDatumData:(PerfectDatumData *)data
{
    if (self = [super init]) {
        _pefectDatumData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    self.title=@"完善资料";
    self.view.backgroundColor = [UIColor background_white];
    self.navigationItem.hidesBackButton = YES;
    
    //创建ui
    [self.view addSubview:self.imgHeader];
    [self.view addSubview:self.btnSetHeader];
    [self.view addSubview:self.txtNickName];
    [self.view addSubview:self.btnMale];
    [self.view addSubview:self.btnFemale];
    [self.view addSubview:self.btnOk];
    [self.view addSubview:self.btnLoginout];
    
    //创建ui约束
    [self addMasconstraint];
}

-(void)addMasconstraint
{
    [self.imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        if (IOS_13) {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        } else {
            make.top.mas_equalTo(STATUS_BAR_SIZE_IOS_LT13.height + self.navigationController.navigationBar.bounds.size.height + 10);
        }
        make.width.height.mas_equalTo(100);
    }];
    self.imgHeader.layer.masksToBounds = YES;
    self.imgHeader.layer.cornerRadius = 50;
    
    UILine_Block;
    
    [self.btnSetHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.left.bottom.right.mas_equalTo(self.imgHeader);
    }];
    
    [self.txtNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.top.mas_equalTo(self.imgHeader.mas_bottom).mas_equalTo(40);
        make.width.mas_equalTo(self.view).mas_offset(-EDGE_LINE * 2);
    }];
    
    UIView *line_1 = createLine();
    [self.view addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.txtNickName.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.txtNickName);
        make.height.mas_equalTo(1);
    }];
    
    [self.btnMale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_1.mas_bottom).mas_equalTo(20);
        make.centerX.mas_equalTo(-60);
    }];
    
    [self.btnFemale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnMale);
        make.centerX.mas_equalTo(60);
    }];
    
    [self.btnOk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnMale.mas_bottom).mas_equalTo(40);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(line_1);
        make.height.mas_equalTo(40);
    }];
    
    [self.btnLoginout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
    }];
    
    self.gender = Gender_Male;
}

-(void)setGender:(NSUInteger)gender
{
    if (Gender_Male != gender && Gender_Female != gender) {
        gender = Gender_Male;
    }
    
    _gender = gender;
    _btnMale.enabled = _gender != Gender_Male;
    _btnFemale.enabled = _gender != Gender_Female;
}

-(void)onSetHeader
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    WEAK_SELF;
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
        
        //拍照获取头像
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!isCameraSupport) {
            [SVProgressHUD showErrorWithStatus:@"设备不支持拍照"];
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction* photoLibary = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        
    }];

    [alert addAction:takePhoto];
    [alert addAction:photoLibary];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onSelMale
{
    self.gender = Gender_Male;
}

-(void)onSelFemale
{
    self.gender = Gender_Female;
}

-(void)onOK
{
    if (_txtNickName.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    
    if (!_imgHeaderData) {
        [SVProgressHUD showErrorWithStatus:@"请设置头像"];
        return;
    }
    
    if (!_pefectDatumData || [NSString isNulOrEmpty:_pefectDatumData.jimId]) {
        [SVProgressHUD showErrorWithStatus:@"抱歉，未知错误"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"处理中..."];
    
    //上传头像
    WEAK_SELF;
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:[self headerData]
                   key:_pefectDatumData.header
                 token:_pefectDatumData.token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (info.error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"头像上传失败,请重试"];
            return;
        }
        
        NSString *head = [NSString stringWithFormat:@"%@/%@",JXMainStatusManager.sharedInstance.serverInfo.headerUrl,weakSelf.pefectDatumData.header];
        RequestPerfectDatum *api = [[RequestPerfectDatum alloc] initWithJimId:weakSelf.pefectDatumData.jimId
                                                                       Header:head
                                                                     NickName:weakSelf.txtNickName.text
                                                                       Gender:weakSelf.gender];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [SVProgressHUD dismiss];
            JIMAccount *account = api.successData;
            if (account && account.isValid) {
                JXUserDataManager.sharedInstance.userData = account;
                [self nimManualLogin];
                ShowMainViewController;
                return;
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"抱歉，请重试"];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:api.respMsg];
            
        }];
        
    }option:nil];
    
    return;
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

-(void)onLoginout
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImageView *)imgHeader
{
    if (!_imgHeader) {
        _imgHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setheader"]];
    }
    return _imgHeader;
}

-(UIButton *)btnSetHeader
{
    if (!_btnSetHeader) {
        _btnSetHeader = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _btnSetHeader.backgroundColor = [UIColor clearColor];
        [_btnSetHeader addTarget:self action:@selector(onSetHeader) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSetHeader;
}


#pragma UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imgHeaderData = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imgHeader.image = self.imgHeaderData;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma Create UIControl

-(NSData *)headerData
{
    if (!_imgHeaderData) {
        return nil;
    }
    
    if ([_pefectDatumData.header hasSuffix:@".png"]) {
        return UIImagePNGRepresentation(_imgHeaderData);
    }
    
    float compressionQuality = [JXMainStatusManager.sharedInstance floatValueByKey:ServerConfigKey_HeaderCompressionQuality withDefaultValue:1.0f];
    return UIImageJPEGRepresentation(_imgHeaderData,compressionQuality);
}

-(UITextField *)txtNickName
{
    if (!_txtNickName) {
        _txtNickName = [[UITextField alloc] init];
        _txtNickName.placeholder = @"输入昵称(必填)";
        _txtNickName.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _txtNickName;
}

-(UIButton *)btnMale
{
    if (!_btnMale) {
        _btnMale = [[UIButton alloc] init];
        [_btnMale.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_btnMale setTitle:@"  男" forState:UIControlStateNormal];
        [_btnMale setTitle:@"  男" forState:UIControlStateDisabled];
        
        [_btnMale setTitleColor:[UIColor text_greybg_darkgrey] forState:UIControlStateNormal];
        [_btnMale setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        
        [_btnMale setImage:[UIImage imageNamed:@"radiobutton_bg"] forState:UIControlStateNormal];
        [_btnMale setImage:[UIImage imageNamed:@"radiobutton_sel"] forState:UIControlStateDisabled];
        
        [_btnMale addTarget:self action:@selector(onSelMale) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMale;
}

-(UIButton *)btnFemale
{
    if (!_btnFemale) {
        _btnFemale = [[UIButton alloc] init];
        [_btnFemale.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [_btnFemale setTitle:@"  女" forState:UIControlStateNormal];
        [_btnFemale setTitle:@"  女" forState:UIControlStateDisabled];
        
        [_btnFemale setTitleColor:[UIColor text_greybg_darkgrey] forState:UIControlStateNormal];
        [_btnFemale setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        
        [_btnFemale setImage:[UIImage imageNamed:@"radiobutton_bg"] forState:UIControlStateNormal];
        [_btnFemale setImage:[UIImage imageNamed:@"radiobutton_sel"] forState:UIControlStateDisabled];
        
        [_btnFemale addTarget:self action:@selector(onSelFemale) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFemale;
}

-(UIButton *)btnOk
{
    if (!_btnOk) {
        _btnOk = [[UIButton alloc] init];
        [_btnOk.layer setMasksToBounds:YES];
        [_btnOk.layer setCornerRadius:5.0f];
        [_btnOk.titleLabel setFont:[UIFont loginRegister_loginButton]];
        [_btnOk setTitle:@"完成" forState:UIControlStateNormal];
        _btnOk.backgroundColor = [UIColor buttonbg_login];
        [_btnOk addTarget:self action:@selector(onOK) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOk;
}

-(UIButton *)btnLoginout
{
    if(!_btnLoginout)
    {
        _btnLoginout = [[UIButton alloc] init];
        [_btnLoginout setTitle:@"退出登录" forState:UIControlStateNormal];
        [_btnLoginout.titleLabel setFont:[UIFont loginRegister_otherLoginButton]];
        [_btnLoginout setTitleColor:[UIColor text_whitebg_blue_light] forState:UIControlStateNormal];
        [_btnLoginout addTarget:self action:@selector(onLoginout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoginout;
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
