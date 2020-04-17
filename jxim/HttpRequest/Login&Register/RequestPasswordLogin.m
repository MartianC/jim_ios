//
//  RequestPasswordLogin.m
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestPasswordLogin.h"

@interface RequestPasswordLogin()

@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *loginPwd;

@end

@implementation RequestPasswordLogin

-(instancetype)initWithPhone:(NSString *)phone andPwd:(NSString *)pwd
{
    if (self = [super init]) {
        _phone = phone;
        _loginPwd = pwd;
    }
    return self;
}

-(JIMAccount *)successData
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
    return RequestUrl_PasswordLogin;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"phoneNum" : _phone,
        @"password" : _loginPwd
    };
}

@end
