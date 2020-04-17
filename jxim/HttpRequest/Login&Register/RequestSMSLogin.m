//
//  RequestSMSLogin.m
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestSMSLogin.h"

@interface RequestSMSLogin()

@property(nonatomic,copy) NSString *codeId;
@property(nonatomic,copy) NSString *code;

@end


@implementation RequestSMSLogin

-(instancetype)initWithSMSCode:(NSString *)code CodeId:(NSString *)codeId
{
    if (self = [super init]) {
        _codeId = codeId;
        _code = code;
    }
    return self;
}

-(PerfectDatumData *)perfectDatumData
{
    NSDictionary *data = self.respData;
    if (!data || data.count < 1) return nil;
    
    PerfectDatumData *result = [[PerfectDatumData alloc] init];
    result.jimId = [data stringValueOfKey:@"jimId"];
    result.header = [data stringValueOfKey:@"header"];
    result.token = [data stringValueOfKey:@"token"];
    
    if (result.isValid) {
        return result;
    }
    
    return nil;
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
    return RequestUrl_SMSLogin;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"codeId":_codeId,
        @"code":_code
    };
}

@end
