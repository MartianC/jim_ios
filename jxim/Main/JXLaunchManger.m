//
//  JXLaunchManger.m
//  jxim
//
//  Created by yangfantao on 2020/3/17.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXLaunchManger.h"
#import "JXPwdLoginViewController.h"
#import "JXFastLoginViewController.h"
#import "JXMainTBC.h"
#import "JXUserDataManager.h"
#import "JXCacheDataManager.h"
#import "NSString+StringExt.h"

@implementation JXLaunchManger

JXSingleton_Impl(JXLaunchManger)

-(void)launchWithWindow:(UIWindow *)window
{
    NSString *loginId = JXCacheDataManager.sharedInstance.loginId;
    
    if([NSString isNulOrEmpty:loginId])
    {
        [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        window.rootViewController = [self loginVC];
    }
    else
    {
        window.rootViewController = [self mainVC];
    }
}

-(UITabBarController *) mainVC
{
    JXMainTBC *mainTBC = [[JXMainTBC alloc] init];
    return mainTBC;
}

-(UIViewController *) loginVC
{
    UINavigationController *nav;
    if (nil == JX_UserDataManager.userData || 0 == JX_UserDataManager.userData.jim_phone.length) {
        nav = [[UINavigationController alloc] initWithRootViewController:[JXPwdLoginViewController new]];
    }
    else
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[JXFastLoginViewController new]];
    }
    
    return nav;
}

@end
