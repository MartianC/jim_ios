//
//  JXCacheDataManager.m
//  jxim
//
//  Created by yangfantao on 2020/3/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXCacheDataManager.h"

//登录id
#define UserDefaultsKey_LoginID                     @"__UserDefaultsKey_LoginID__"

@implementation JXCacheDataManager

JXSingleton_Impl(JXCacheDataManager)

-(instancetype)init
{
    if (self = [super init]) {
        [self initCacheData];
    }
    return self;
}

-(void)initCacheData
{
    _loginId = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_LoginID];
}

-(void)setLoginId:(NSString *)loginId
{
    if ([NSString isNulOrEmpty:loginId]) {
        [self cleanLoginId];
        return;
    }
    _loginId = loginId;
    
    [[NSUserDefaults standardUserDefaults] setObject:_loginId forKey:UserDefaultsKey_LoginID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)cleanLoginId
{
    _loginId = @"";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultsKey_LoginID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
