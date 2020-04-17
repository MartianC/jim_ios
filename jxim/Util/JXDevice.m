//
//  JXDevice.m
//  NIM
//
//  Created by chris on 15/9/18.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "JXDevice.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

#define NormalImageSize       (1280 * 960)


@interface JXDevice ()

@property (nonatomic,copy)      NSDictionary    *networkTypes;

@end

@implementation JXDevice

- (instancetype)init
{
    if (self = [super init])
    {
        [self buildDeviceInfo];
    }
    return self;
}


+ (JXDevice *)currentDevice{
    static JXDevice *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXDevice alloc] init];
    });
    return instance;
}

- (void)buildDeviceInfo
{
    _networkTypes = @{
                          CTRadioAccessTechnologyGPRS:@(JXNetworkType2G),
                          CTRadioAccessTechnologyEdge:@(JXNetworkType2G),
                          CTRadioAccessTechnologyWCDMA:@(JXNetworkType3G),
                          CTRadioAccessTechnologyHSDPA:@(JXNetworkType3G),
                          CTRadioAccessTechnologyHSUPA:@(JXNetworkType3G),
                          CTRadioAccessTechnologyCDMA1x:@(JXNetworkType3G),
                          CTRadioAccessTechnologyCDMAEVDORev0:@(JXNetworkType3G),
                          CTRadioAccessTechnologyCDMAEVDORevA:@(JXNetworkType3G),
                          CTRadioAccessTechnologyCDMAEVDORevB:@(JXNetworkType3G),
                          CTRadioAccessTechnologyeHRPD:@(JXNetworkType3G),
                          CTRadioAccessTechnologyLTE:@(JXNetworkType4G),
                     };
    
}


//图片/音频推荐参数
- (CGFloat)suggestImagePixels{
    return NormalImageSize;
}

- (CGFloat)compressQuality{
    return 0.5;
}


//App状态
- (BOOL)isUsingWifi{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status =  [reachability currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

- (BOOL)isInBackground{
    return [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive;
}

- (JXNetworkType)currentNetworkType{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status =  [reachability currentReachabilityStatus];
    switch (status) {
        case ReachableViaWiFi:
            return JXNetworkTypeWifi;
        case ReachableViaWWAN:
        {
            CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSNumber *number = [_networkTypes objectForKey:telephonyInfo.currentRadioAccessTechnology];
            return number ? (JXNetworkType)[number integerValue] : JXNetworkTypeWwan;
        }
        default:
            return JXNetworkTypeUnknown;
    }
}


- (NSString *)networkStatus:(JXNetworkType)networkType
{
    switch (networkType) {
        case JXNetworkType2G:
            return @"2G";
        case JXNetworkType3G:
            return @"3G";
        case JXNetworkType4G:
            return @"4G";
        default:
            return @"WIFI";
    }
}

- (NSInteger)cpuCount{
    size_t size = sizeof(int);
    int results;
    
    int mib[2] = {CTL_HW, HW_NCPU};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (BOOL)isLowDevice{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[NSProcessInfo processInfo] processorCount] <= 1;
#endif
}

- (BOOL)isIphone{
    NSString *deviceModel = [UIDevice currentDevice].model;
    if ([deviceModel isEqualToString:@"iPhone"]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)machineName{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


- (CGFloat)statusBarHeight{
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    return height;
}


@end
