//
//  JXUserDataManager.m
//  jxim
//
//  Created by yangfantao on 2020/3/18.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXUserDataManager.h"

#define UserDefaultsKey_UserData                    @"__UserDefaultsKey_UserData__"

@implementation JXUserDataManager

JXSingleton_Impl(JXUserDataManager)

-(instancetype) init
{
    if (self = [super init]) {
        [self loadUserData];
    }
    return self;
}

-(void) loadUserData
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_UserData];
    _userData = [JIMAccount unarchiveObjectWithData:data];
}

-(JXLoginData *)loginData
{
    JXLoginData *loginData = [[JXLoginData alloc] init];
    
    loginData.nimAccount = @"yangfantao";//self.userData.nim_accid;
    loginData.nimToken = @"yangfantao";//self.userData.nim_token;
    return loginData;
}

-(void) setUserData:(JIMAccount *)userData
{
    _userData = userData;
    if (!userData) {
        [self cleanUseDataCache];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[_userData archivedData] forKey:UserDefaultsKey_UserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) cleanUseDataCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultsKey_UserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
