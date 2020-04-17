//
//  RequestModifyPhone.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestModifyPhone.h"

@interface RequestModifyPhone()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *codeId;

@end

@implementation RequestModifyPhone

- (instancetype)initWithJimId:(NSString *)jimId Code:(NSString *)code CodeId:(NSString *)codeId{
    if (self = [super init]) {
        self.jimId = jimId;
        self.code = code;
        self.codeId = codeId;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ModifyPhone;
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
    };
}


@end
