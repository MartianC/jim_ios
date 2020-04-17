//
//  RegisterByPhone.m
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RegisterByPhone.h"

@interface RegisterByPhone()

@property(nonatomic,copy) NSString *codeId;
@property(nonatomic,copy) NSString *code;

@end

@implementation RegisterByPhone

-(instancetype)initWithSMSCode:(NSString *)code CodeId:(NSString *)codeId
{
    if (self = [super init]) {
        _codeId = codeId;
        _code = code;
    }
    return self;
}

-(PerfectDatumData *)resultData
{
    NSDictionary *data = self.respData;
    if (!data || data.count < 1) return nil;
    
    PerfectDatumData *result = [[PerfectDatumData alloc] init];
    result.jimId = [data stringValueOfKey:@"jimId"];
    result.header = [data stringValueOfKey:@"header"];
    result.token = [data stringValueOfKey:@"token"];
    
    return result;
}

-(NSString *)requestUrl
{
    return RequestUrl_RegisterByPhone;
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
