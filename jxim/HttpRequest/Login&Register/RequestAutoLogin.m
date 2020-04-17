//
//  RequestAutoLogin.m
//  jxim
//
//  Created by yangfantao on 2020/4/8.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestAutoLogin.h"

@interface RequestAutoLogin()

@property(nonatomic,copy) NSString *jimId;

@end

@implementation RequestAutoLogin

-(instancetype)initWithJimId:(NSString *)jimId
{
    if (self = [super init]) {
        _jimId = jimId;
    }
    return self;
}

-(JIMAccount *)jimAccount
{
    NSDictionary *data = self.respData;
    if (!data || data.count < 1) return nil;
    
    return [JIMAccount unarchiveObjectWithDictionary:data];
    
//    JIMAccount *account = [[JIMAccount alloc] init];
//
//    account.jim_uniqueid = [data stringValueOfKey:@"jim_uniqueid"];
//    account.jim_account = [data stringValueOfKey:@"jim_account"];
//    account.jim_phone = [data stringValueOfKey:@"jim_phone"];
//    account.jim_status = [data integerValueOfKey:@"jim_status"];
//    account.jim_nickname = [data stringValueOfKey:@"jim_nickname"];
//    account.jim_header = [data stringValueOfKey:@"jim_header"];
//    account.jim_gender = [data integerValueOfKey:@"jim_gender"];
//    account.nim_accid = [data stringValueOfKey:@"nim_accid"];
//    account.nim_token = [data stringValueOfKey:@"nim_token"];
//    account.alipay_aliid = [data stringValueOfKey:@"alipay_aliid"];
//    account.wechat_openid = [data stringValueOfKey:@"wechat_openid"];
//
//    return account;
}


-(NSString *)requestUrl
{
    return RequestUrl_AutoLogin;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return @{
        @"jimId":_jimId,
        @"cliType":@"ios",
        @"cliVerNum":[infoDictionary objectForKey:@"CFBundleVersion"],
        @"cliVerValue":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
        @"deviceId":@""
    };
}

@end
