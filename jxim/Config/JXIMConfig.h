//
//  JXIMConfig.h
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXRedPacketConfig : NSObject

@property (nonatomic,strong)  NSString *aliPaySchemeUrl;
@property (nonatomic,strong)  NSString *weChatSchemeUrl;

@end

@interface JXIMConfig : NSObject

+ (instancetype)sharedConfig;

@property (nonatomic,copy)    NSString          *appKey;
@property (nonatomic,copy)    NSString          *apnsCername;
@property (nonatomic,copy)    NSString          *pkCername;
@property (nonatomic,strong)  JXRedPacketConfig *redPacketConfig;

@end

NS_ASSUME_NONNULL_END
