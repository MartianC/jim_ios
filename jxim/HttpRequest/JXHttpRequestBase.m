//
//  JXHttpRequestBase.m
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

@implementation JXHttpRequestBase

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

-(id)jsonValidator
{
    return @{
        @"resp":@{
            @"status":[NSNumber class],
            @"msg":[NSString class]
        }
    };
}

-(NSInteger)respStatus
{
    if (!self.responseJSONObject) {
        return -1;
    }
    
    NSDictionary *status = self.responseJSONObject;
    
    NSDictionary *resp = [status objectValueOfKey:@"resp"];
    if (nil == resp || resp.count < 0) {
        return -1;
    }
    return [[resp objectForKey:@"status"] intValue];
}

-(NSString *)respMsg
{
    if (!self.responseJSONObject) {
        return @"网络请求错误";
    }
    
    NSDictionary *status = self.responseJSONObject;
    
    NSDictionary *resp = [status objectValueOfKey:@"resp"];
    if (nil == resp || resp.count < 0) {
        return @"";
    }
    return [resp stringValueOfKey:@"msg"];
}

-(NSDictionary *)respData
{
    if (!self.responseJSONObject) {
        return nil;
    }
    
    NSDictionary *status = self.responseJSONObject;
    if (nil == status || status.count < 0) {
        return nil;
    }
    return [status objectValueOfKey:@"data"];
}

@end
