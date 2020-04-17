//
//  JXMainTBC.m
//  jxim
//
//  Created by yangfantao on 2020/3/22.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMainTBC.h"
#import "JXSessionListVC.h"
#import "JXContactsVC.h"
#import "JXYouLiaoVC.h"
#import "JXMineVC.h"
#import "JXIMGlobalDef.h"
#import "UIColor+ColorExt.h"
#import "JXMainStatusManager.h"
#import "JXCacheDataManager.h"
#import "JXUserDataManager.h"
#import "AppDelegate.h"
#import "NSString+StringExt.h"
#import "TarBarNVC.h"

@interface JXMainTBC ()//<NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate>

@end

@implementation JXMainTBC

+ (instancetype)instance{
    JXIMAppDelegate *delegete = (JXIMAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[JXMainTBC class]]) {
        return (JXMainTBC *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSubNav];
    [self setUpCache];
}

- (void)dealloc{
//    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
//    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpSubNav
{
    self.viewControllers = [NSArray arrayWithObjects:[self left1NVC], [self left2NVC], [self left3NVC], [self left4NVC], nil];
    
    //默认选中
    NSInteger defaultIdx = [JXMainStatusManager.sharedInstance intValueByKey:ServerConfigKey_DefaultTarbarIdx withDefaultValue:0];
    if (defaultIdx < 0 || defaultIdx >= self.viewControllers.count) {
        defaultIdx = 0;
    }
    self.selectedIndex = defaultIdx;
}

-(void)setUpCache
{
    NSString *jimId = JXUserDataManager.sharedInstance.userData.jim_uniqueid;
    if (![NSString isNulOrEmpty:jimId]) {
        JXCacheDataManager.sharedInstance.loginId = jimId;
    }
}

//左1
-(UINavigationController *) left1NVC
{
    return [self nvcWithVC:[JXSessionListVC new] andTitle:@"消息" andImg:@"tabbar_sessionlist" andHLImg:@"tabbar_sessionlist_hl"];
}

//左2
-(UINavigationController *) left2NVC
{
    return [self nvcWithVC:[JXContactsVC new] andTitle:@"通讯录" andImg:@"tabbar_contacts" andHLImg:@"tabbar_contacts_hl"];
}

//左3
-(UINavigationController *) left3NVC
{
    return [self nvcWithVC:[JXYouLiaoVC new] andTitle:@"有料" andImg:@"tabbar_youliao" andHLImg:@"tabbar_youliao_hl"];
}

//左4
-(UINavigationController *) left4NVC
{
    return [self nvcWithVC:[JXMineVC new] andTitle:@"我" andImg:@"tabbar_mine" andHLImg:@"tabbar_mine_hl"];
}

-(UINavigationController *)nvcWithVC:(UIViewController *)vc andTitle:(NSString *)title andImg:(NSString *)img andHLImg:(NSString *)imgHL
{
    if (nil == vc) return nil;
    
    UINavigationController *nvc = [[TarBarNVC alloc] initWithRootViewController:vc];
    
    [nvc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    nvc.navigationBar.shadowImage = [[UIImage alloc] init];
    
    nvc.navigationBar.translucent = NO;
    nvc.view.backgroundColor = [UIColor whiteColor];
    nvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                  image:[UIImage imageNamed:img]
                                           selectedImage:[UIImage imageNamed:imgHL]];
    //[nvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    [nvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorOrangeColor]} forState:UIControlStateSelected];
    return nvc;
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
