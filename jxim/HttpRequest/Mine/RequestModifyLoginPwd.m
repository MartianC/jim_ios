//
//  RequestModifyLoginPwd.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestModifyLoginPwd.h"

@interface RequestModifyLoginPwd()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *oldPwd;
@property(nonatomic,copy) NSString *pwd;

@end

@implementation RequestModifyLoginPwd

- (instancetype)initWithJimId:(NSString *)jimId OldPwd:(nonnull NSString *)oldPwd NewPwd:(nonnull NSString *)newPwd{
    if (self = [super init]) {
        self.jimId = jimId;
        self.oldPwd = oldPwd;
        self.pwd = newPwd;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ModifyLoginPwd;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId"    : _jimId,
        @"oldpwd"   : _oldPwd,
        @"newpwd"   : _pwd,
    };
}


@end
