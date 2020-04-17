//
//  RequestResetLoginPwd.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestResetLoginPwd.h"

@interface RequestResetLoginPwd()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *pwd;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *codeId;

@end

@implementation RequestResetLoginPwd

- (instancetype)initWithJimId:(NSString *)jimId Pwd:(NSString *)pwd Code:(NSString *)code CodeId:(NSString *)codeId{
    if (self = [super init]) {
        self.jimId = jimId;
        self.pwd = pwd;
        self.code = code;
        self.codeId = codeId;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ResetLoginPwd;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId"    : _jimId,
        @"code"     : _code,
        @"codeId"   : _codeId,
        @"loginPwd" : _pwd,
    };
}


@end
