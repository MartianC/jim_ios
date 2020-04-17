//
//  JXIMConfig.m
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXIMConfig.h"
#import <NIMSDK/NIMSDK.h>

@implementation JXRedPacketConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _aliPaySchemeUrl = @"alipay052969";
        _weChatSchemeUrl = @"wx2a5538052969956e";
    }
    return self;
}

@end

@implementation JXIMConfig


+ (instancetype)sharedConfig
{
    static JXIMConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXIMConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"48e10bbc54faffee3573b4076e98af69";
        _pkCername = @"DEMO_PUSH_KIT";
        
#ifdef DEBUG
        _apnsCername = @"DEVELOPER";
#else
        _apnsCername = @"ENTERPRISE";
#endif
        
        _redPacketConfig = [[JXRedPacketConfig alloc] init];
    }
    return self;
}

@end
