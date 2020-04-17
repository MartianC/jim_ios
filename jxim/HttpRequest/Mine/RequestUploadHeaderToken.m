//
//  RequestUploadHeaderToken.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestUploadHeaderToken.h"

@interface RequestUploadHeaderToken()

@property(nonatomic,copy) NSString *jimId;

@end

@implementation RequestUploadHeaderToken

-(instancetype)initWithJimId:(NSString *)jimId
{
    if (self = [super init]) {
        _jimId = jimId;
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


-(NSString *)requestUrl
{
    return RequestUrl_UploadHeaderToken;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
    };
}

@end
