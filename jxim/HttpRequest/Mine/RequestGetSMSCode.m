//
//  RequestGetSMSCode.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/15.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestGetSMSCode.h"

@interface RequestGetSMSCode()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *phone;

@end

@implementation RequestGetSMSCode

-(instancetype)initWithJimId:(NSString *)jimId Phone:(nonnull NSString *)phone
{
    if (self = [super init]) {
        _jimId = jimId;
        _phone = phone;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_GetSMSCode;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
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

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
        @"phone" : _phone,
    };
}

@end
