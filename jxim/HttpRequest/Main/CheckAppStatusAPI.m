//
//  CheckAppStatusAPI.m
//  jxim
//
//  Created by yangfantao on 2020/3/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "CheckAppStatusAPI.h"

@implementation CheckAppStatusAPI

-(NSString *)requestUrl
{
    return @"http://jimcommonwebapi.yyd6.com/api/common/checkstatus";
}

-(id)requestArgument
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    return @{
        @"clitype":@"ios",
        @"clivernum":[infoDictionary objectForKey:@"CFBundleVersion"],
        @"clivervalue":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
        @"deviceplatform":[infoDictionary objectForKey:@"DTPlatformName"],
        @"deviceplatformver":[infoDictionary objectForKey:@"DTPlatformVersion"]
    };
}

@end
