//
//  JXDevice.h
//  NIM
//
//  Created by chris on 15/9/18.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JXNetworkType) {
    JXNetworkTypeUnknown,
    JXNetworkTypeWifi,
    JXNetworkTypeWwan,
    JXNetworkType2G,
    JXNetworkType3G,
    JXNetworkType4G,
};

@interface JXDevice : NSObject

+ (JXDevice *)currentDevice;

//图片/音频推荐参数
- (CGFloat)suggestImagePixels;
- (CGFloat)compressQuality;

//App状态
- (BOOL)isUsingWifi;
- (BOOL)isInBackground;

- (JXNetworkType)currentNetworkType;
- (NSString *)networkStatus:(JXNetworkType)networkType;

- (NSInteger)cpuCount;

- (BOOL)isLowDevice;
- (BOOL)isIphone;
- (NSString *)machineName;


- (CGFloat)statusBarHeight;

@end
