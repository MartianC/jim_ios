//
//  RequestRegisterSMSCode.m
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestRegisterSMSCode.h"

@interface RequestRegisterSMSCode()

@property(nonatomic,copy) NSString *phoneNum;

@end

@implementation RequestRegisterSMSCode

-(instancetype)initWithPhone:(NSString *)phone
{
    if (self = [super init]) {
        _phoneNum = phone;
    }
    return self;
}

-(nullable RegisterSMSCodeData *)codeData
{
    NSDictionary *data = self.respData;
    if (!data || data.count < 1) return nil;
    
    RegisterSMSCodeData *result = [[RegisterSMSCodeData alloc] init];
    result.codeId = [data stringValueOfKey:@"codeId"];
    result.code = [data stringValueOfKey:@"code"];
    
    if (!result.code || !result.codeId)return nil;
    return result;
}

-(NSString *)requestUrl
{
    return [NSString stringWithFormat:@"%@/%@",RequestUrl_RegisterSMSCode,_phoneNum];
}

@end
