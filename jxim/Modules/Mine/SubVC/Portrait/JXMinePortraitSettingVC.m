//
//  JXMinePortraitSettingVC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/11.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMinePortraitSettingVC.h"
#import "JXUserDataManager.h"
#import <SDWebImage.h>
#import "Masonry.h"
#import <SVProgressHUD.h>
#import "QNUploadManager.h"
#import "QNResponseInfo.h"
#import "PerfectDatumData.h"
#import "JXMainStatusManager.h"
#import "RequestPerfectDatum.h"
#import "RequestUploadHeaderToken.h"
#import "RequestModifyHeader.h"

@interface JXMinePortraitSettingVC ()

@property (nonatomic,strong) UIImageView *header;

@property(nonatomic,strong) UIImage *imgHeaderData;

@property(nonatomic,strong) PerfectDatumData *pefectDatumData;

@end

@implementation JXMinePortraitSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"个人头像";
    //底栏
    [self.tabBarController.tabBar setHidden:YES];
    //状态栏
    //[self setStarusBarDark:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    //[self setStarusBarDark:NO];
}


- (void)loadUI{
    //导航栏定制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_barbutton_changeAvatar"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                            action:@selector(onChangeAvatar)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview: bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(-144.f);
        make.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
    
    self.header = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.header];
    JIMAccount *user = JXUserDataManager.sharedInstance.userData;
    [self.header sd_setImageWithURL:[NSURL URLWithString:user.jim_header]];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(self.view.mas_width);
        make.centerX.and.centerY.mas_equalTo(self.view);
    }];
}

- (void) refreshHeader{
    JIMAccount *user = JXUserDataManager.sharedInstance.userData;
    [self.header sd_setImageWithURL:[NSURL URLWithString:user.jim_header]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setStarusBarDark:(BOOL) isDark{
    if (@available(iOS 13.0, *)) {
        if(isDark && self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
        {//已经在暗黑模式 直接返回
            return;
        }
        //状态栏字体颜色
        [UIApplication sharedApplication].statusBarStyle = isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        //标题栏
        if (isDark) {
            UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
            [barAppearance configureWithTransparentBackground];
            [barAppearance setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [self.navigationController.navigationBar setStandardAppearance:barAppearance];
        }
        else {
            UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
            [self.navigationController.navigationBar setStandardAppearance:barAppearance];
        }
        
    }
    else {
        //字体颜色
        [UIApplication sharedApplication].statusBarStyle = isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        //背景颜色
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                   if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                       statusBar.backgroundColor = isDark ? [UIColor blackColor] : [UIColor whiteColor];
                   }
    }
}

- (void)onChangeAvatar{
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

-(NSData *)headerData
{
    if (!_imgHeaderData) {
        return nil;
    }
    
    float compressionQuality = [JXMainStatusManager.sharedInstance floatValueByKey:ServerConfigKey_HeaderCompressionQuality withDefaultValue:1.0f];
    return UIImageJPEGRepresentation(_imgHeaderData,compressionQuality);
}


#pragma UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imgHeaderData = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //上传头像
    //WEAK_SELF;
    JIMAccount *user = JX_UserDataManager.userData;
    //获得token
    RequestUploadHeaderToken *api = [[RequestUploadHeaderToken alloc] initWithJimId:user.jim_uniqueid];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [SVProgressHUD dismiss];
        PerfectDatumData *result = [api perfectDatumData];
        if (result) {
            //上传头像
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:[self headerData]
                           key:result.header
                         token:result.token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if (info.error) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"头像上传失败,请重试"];
                    return;
                }
                //更新到服务器
                NSString *head = [NSString stringWithFormat:@"%@/%@",JXMainStatusManager.sharedInstance.serverInfo.headerUrl,result.header];
                RequestModifyHeader *api2 = [[RequestModifyHeader alloc] initWithJimId:result.jimId
                                                                               Header:head];
                [api2 startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    //更新成功
                    JXUserDataManager.sharedInstance.userData.jim_header = head;
                    [self refreshHeader];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"头像上传失败,请重试"];
                }];
                
            } option:nil];
            return;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"头像上传失败,请重试"];
    }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end



