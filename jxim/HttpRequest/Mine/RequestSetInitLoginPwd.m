//
//  RequestSetInitLoginPwd.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/15.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestSetInitLoginPwd.h"

@interface RequestSetInitLoginPwd()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *pwd;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *codeId;

@end

@implementation RequestSetInitLoginPwd

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
    return RequestUrl_SetInitLoginPwd;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId"    : _jimId,
        @"password" : _pwd,
        @"code"     : _code,
        @"codeId"   : _codeId,
    };
}


@end
