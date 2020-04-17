//
//  AppDelegate.m
//  jxim
//
//  Created by yangfantao on 2020/3/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetwork.h"
#import "JXLaunchManger.h"
#import "NSString+StringExt.h"
#import "CheckAppStatusAPI.h"
#import "JXCacheDataManager.h"
#import "JXMainStatusManager.h"
#import "JXSpellingCenter.h"
#import "SVProgressHUD.h"
#import "NSString+StringExt.h"
#import "RequestAutoLogin.h"
#import "JXUserDataManager.h"
#import "NIMKit.h"
#import "JXSDKConfigDelegate.h"
#import <TZImagePickerController/TZLocationManager.h>
#import "JXRedPacketManager.h"
#import "JXPrivatizationManager.h"
#import "JXBundleSetting.h"
#import "JXIMConfig.h"
#import "JXCustomAttachmentDecoder.h"
#import "JXCellLayoutConfig.h"
#import "JXDbExceptionHandler.h"
#import "JXSubscribeManager.h"
#import "JXNotificationCenter.h"
#import <NIMSDK/NIMSDK.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import "UIView+Toast.h"
#import "JXUserDataManager.h"
#import "JXClientUtil.h"
#import "JXSessionUtil.h"
#import "JXDevice.h"

@import PushKit;

NSString *JXNotificationLogout = @"__JXIMNotificationLogout__";

@interface JXIMAppDelegate ()<NIMLoginManagerDelegate,PKPushRegistryDelegate>

@property (nonatomic,strong) JXSDKConfigDelegate *sdkConfigDelegate;

@end

@implementation JXIMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //全局配置
    [self globalConfig];
    
    if (@available(iOS 13.0, *)) {
        [[TZLocationManager manager] startLocation];//sdk 获取wifi信息需要使用
    }

    [self setupNIMSDK];
    [self setupServices];
    [self setupCrashlytics];

    [self registerPushService];
    [self commonInitListenEvents];

    [[JXRedPacketManager sharedManager] application:application didFinishLaunchingWithOptions:launchOptions];
    
    CheckAppStatusAPI *api = [[CheckAppStatusAPI alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkStatusComplete:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkStatusComplete:request];
    }];

    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

#pragma mark - config & start

-(void)globalConfig
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.toolbarDoneBarButtonItemText=@"完成";
    
    [SVProgressHUD setBackgroundColor:[UIColor grayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

-(void) initConfig
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [JXMainStatusManager sharedInstance].serverInfo.serverUrl;
    config.cdnUrl = @"";
    config.debugLogEnabled = YES;
}

-(void) checkStatusComplete:(JXHttpRequestBase *)request
{
    if (0 == request.respStatus) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:request.responseJSONObject] forKey:UserDefaultsKey_StatusData];
    }
    
    NSInteger launchDelay = [JXMainStatusManager sharedInstance].serverInfo.launchDelay;
    if (launchDelay > 0) {
        [NSThread sleepForTimeInterval:(float)launchDelay/1000.0f];
    }
    
    //初始化配置
    [self initConfig];

    NSString *loginId = [JXCacheDataManager sharedInstance].loginId;
    if ([NSString isNulOrEmpty:loginId]) {
        [self start];
    }
    else
    {
        if ([[JXDevice currentDevice] currentNetworkType] == JXNetworkTypeUnknown) {
            //没有网络或者访问服务器失败等网络原因，默认登录
            [self nimAutoLogin];
            [self start];
            return;
        }
        
        RequestAutoLogin *api = [[RequestAutoLogin alloc] initWithJimId:loginId];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (0 == api.respStatus) {
                
                JIMAccount *account = [api jimAccount];
                if (account && account.isValid) {
                    JXUserDataManager.sharedInstance.userData = account;
                    [self nimAutoLogin];
                    [self start];
                    return;
                }
            }
            
            //到这里，说明是服务端不允许自动登录
            [JXCacheDataManager.sharedInstance cleanLoginId];
            [self start];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //没有网络或者访问服务器失败等网络原因，默认登录
            [self nimAutoLogin];
            [self start];
        }];
    }
}

-(void)start
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[JXLaunchManger sharedInstance] launchWithWindow:self.window];
}

-(void)nimAutoLogin
{
    JXLoginData *data = [JXUserDataManager.sharedInstance loginData];
    NSString *account = data.nimAccount;
    NSString *token = data.nimToken;
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        [[JXServiceManager sharedManager] start];
    }
}

#pragma mark - setup more

- (void)setupNIMSDK
{
    //私有化配置检查
    [[JXPrivatizationManager sharedInstance] setupPrivatization];
    
    //配置额外配置信息 -- 需要在注册 appkey 前完成
    self.sdkConfigDelegate = [[JXSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setEnabledHttpsForInfo:NO];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    [[NIMSDKConfig sharedConfig] setMaximumLogDays:[[JXBundleSetting sharedConfig] maximumLogDays]];
    [[NIMSDKConfig sharedConfig] setShouldCountTeamNotification:[[JXBundleSetting sharedConfig] countTeamNotification]];
    [[NIMSDKConfig sharedConfig] setAnimatedImageThumbnailEnabled:[[JXBundleSetting sharedConfig] animatedImageThumbnailEnabled]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceiving:[[JXBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceivingInChatroom:[[JXBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setAsyncLoadRecentSessionEnabled:[JXBundleSetting sharedConfig].asyncLoadRecentSessionEnabled];
    
    
    //多端登录时，告知其他端，这个端的登录类型，目前对于android的TV端，手表端使用。
    [[NIMSDKConfig sharedConfig] setCustomTag:[NSString stringWithFormat:@"%ld",(long)NIMLoginClientTypeiOS]];
    // link 网络类型
    NIMLinkAddressType linkAddressType = [JXBundleSetting sharedConfig].LbsLinkAddressType;
    [NIMSDK sharedSDK].serverSetting.lbsLinkAddressType = linkAddressType;

    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = [[JXIMConfig sharedConfig] appKey];
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = [[JXIMConfig sharedConfig] apnsCername];
    option.pkCername        = [[JXIMConfig sharedConfig] pkCername];
    
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[JXCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[JXCellLayoutConfig new]];
    
    BOOL isUsingDemoAppKey = [[NIMSDK sharedSDK] isUsingDemoAppKey];
    [[NIMSDKConfig sharedConfig] setTeamReceiptEnabled:isUsingDemoAppKey];
    
    JXDbExceptionHandler * handler = [[JXDbExceptionHandler alloc] init];
    [NIMDatabaseException registerExceptionHandler:handler];
    
    //场景配置
    NSMutableDictionary *dict = @{@"jxim_gamechat":@1}.mutableCopy;
    [[NIMSDK sharedSDK] setSceneDict:dict];
}

- (void)setupServices
{
//    [[JXLogManager sharedManager] start];
    [[JXNotificationCenter sharedCenter] start];
    [[JXSubscribeManager sharedManager] start];
    [[JXRedPacketManager sharedManager] start];
}

- (void)setupCrashlytics
{
   //Fabric 崩溃统计
   // [Fabric with:@[[Crashlytics class]]];
}

- (void)registerPushService
{
    if (@available(iOS 11.0, *))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                dispatch_async_main_safe(^{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"请开启推送功能否则无法收到推送通知" duration:2.0 position:CSToastPositionCenter];
                });
            }
        }];
    }
    else
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //pushkit
//    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
//    pushRegistry.delegate = self;
//    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];

    
    // 注册push权限，用于显示本地推送
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:JXNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

#pragma mark - ApplicationDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self userPreferencesConfig];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * key = [[JXBundleSetting sharedConfig] customAPNsType];
    key = [key isEqualToString:@"nil"] ? nil : key;
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken
                       customContentKey:key];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receive remote notification:  %@", userInfo);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to get apns token :%@",error);
}

- (void)userPreferencesConfig
{
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceiving:[[JXBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceivingInChatroom:[[JXBundleSetting sharedConfig] autoFetchAttachment]];
    
    BOOL disable =  [[JXBundleSetting sharedConfig] enableAudioSessionReset];
    [[NIMSDK sharedSDK].mediaManager disableResetAudioSession:disable];
}


#pragma mark - PKPushRegistryDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
        [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    NSLog(@"receive payload %@ type %@", payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]])
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    NSLog(@"registry %@ invalidate %@",registry,type);
}


#pragma mark - openURL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[JXRedPacketManager sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [[JXRedPacketManager sharedManager] application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //目前只有红包跳转
    return [[JXRedPacketManager sharedManager] application:application handleOpenURL:url];
}


#pragma mark - 注销
-(void)logout:(NSNotification *)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[JXServiceManager sharedManager] destory];
    [self setupLoginViewController];
}

- (void)setupLoginViewController
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    [JXCacheDataManager.sharedInstance cleanLoginId];
    [[JXLaunchManger sharedInstance] launchWithWindow:self.window];
}

#pragma mark - NIMLoginManagerDelegate

/**
 *  登录回调
 *
 *  @param step 登录步骤
 *  @discussion 这个回调主要用于客户端UI的刷新
 */
- (void)onLogin:(NIMLoginStep)step
{
    NSLog(@"NIMLoginManagerDelegate --> onLogin --> %ld",step);
}

//踢出
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"您的账号在其他设备登录，请注意账号安全";
    if (code == NIMKickReasonByServer) {
        reason = @"抱歉，您被系统强制退出";
    }
    
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:JXNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"游聊提示" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

//自动登录失败回调
- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    NSLog(@"onAutoLoginFailed %@",error);
    [self showAutoLoginErrorAlert:error];
}

//显示自动登录失败错误信息并引导玩家进入手动登录
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    UIAlertController *vc = nil;
    
    //sdk 自动登录次数达到上限且登录失败
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        vc = [UIAlertController alertControllerWithTitle:@"登录失败"
                                                 message:@"抱歉，账号登录失败"
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                JXLoginData *data = [JXUserDataManager.sharedInstance loginData];
                                                                NSString *account = data.nimAccount;
                                                                NSString *token = data.nimToken;
                                                                if ([account length] && [token length])
                                                                {
                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                                                                    loginData.account = account;
                                                                    loginData.token = token;
                                                                    
                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                                                                }
                                                            }];
        [vc addAction:retryAction];
    }
    else
    {
        vc = [UIAlertController alertControllerWithTitle:@"账号过期"
                                                 message:@"抱歉，您的账号已过期需要重新登录"
                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:JXNotificationLogout object:nil];
                                                                 }];
                                                             }];
        [vc addAction:logoutAction];
    }
    
    if (vc) {
        
        [self.window.rootViewController presentViewController:vc
                                                     animated:YES
                                                   completion:nil];
        
    }
}

@end
