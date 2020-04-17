//
//  RequestModifyGender.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RequestModifyGender.h"

@interface RequestModifyGender()

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,assign) NSUInteger gender;

@end

@implementation RequestModifyGender

-(instancetype)initWithJimId:(NSString *)jimId Gender:(NSUInteger)gender
{
    if (self = [super init]) {
        _jimId = jimId;
        _gender = gender;
    }
    return self;
}

-(NSString *)requestUrl
{
    return RequestUrl_ModifyGender;
}

-(YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

-(id)requestArgument
{
    return @{
        @"jimId" : _jimId,
        @"gender" : [NSNumber numberWithUnsignedLong:_gender]
    };
}

@end
