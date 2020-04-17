//
//  PerfectDatumData.m
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "PerfectDatumData.h"
#import "NSString+StringExt.h"

@implementation PerfectDatumData

-(instancetype)init
{
    if (self = [super init]) {
        _jimId = @"";
        _header = @"";
        _token = @"";
    }
    return self;
}

-(BOOL)isValid
{
    if ([NSString isNulOrEmpty:_jimId] || [NSString isNulOrEmpty:_header] || [NSString isNulOrEmpty:_token]) {
        return NO;
    }
    return YES;
}

@end
