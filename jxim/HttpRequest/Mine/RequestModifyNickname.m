//
//  RequestModifyNickname.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestModifyNickname.h"

@interface RequestModifyNickname()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *nickname;

@end

@implementation RequestModifyNickname

-(instancetype)initWithJimId:(NSString *)jimId Nickname:(nonnull NSString *)nickname
{
    if (self = [super init]) {
        _jimId = jimId;
        _nickname = nickname;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ModifyNickname;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
        @"nickName" : _nickname,
    };
}

@end
