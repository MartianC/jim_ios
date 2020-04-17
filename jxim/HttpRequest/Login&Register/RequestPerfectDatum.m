//
//  RequestPerfectDatum.m
//  jxim
//
//  Created by yangfantao on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestPerfectDatum.h"

@interface RequestPerfectDatum()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *header;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,assign) NSUInteger gender;

@end

@implementation RequestPerfectDatum

-(instancetype)initWithJimId:(NSString *)jimId Header:(NSString *)header NickName:(NSString *)nickName Gender:(NSUInteger)gener
{
    if (self = [super init]) {
        _jimId = jimId;
        _header = header;
        _nickName = nickName;
        _gender = gener;
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
    return RequestUrl_PefectDatum;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
        @"header" : _header,
        @"nickName" : _nickName,
        @"gender" : [NSNumber numberWithUnsignedLong:_gender]
    };
}

@end
