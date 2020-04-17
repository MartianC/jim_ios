//
//  RequestModifyHeader.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestModifyHeader.h"

@interface RequestModifyHeader()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *header;

@end

@implementation RequestModifyHeader

-(instancetype)initWithJimId:(NSString *)jimId Header:(NSString *)header
{
    if (self = [super init]) {
        _jimId = jimId;
        _header = header;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ModifyHeader;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
        @"header" : _header,
    };
}

@end
