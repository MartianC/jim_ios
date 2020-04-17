//
//  JXRedPacketManager.h
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXRedPacketManager : NSObject


+ (instancetype)sharedManager;

- (void)start;

- (void)updateUserInfo;

- (void)sendRedPacket:(NIMSession *)session;

- (void)openRedPacket:(NSString *)redpacketId
                 from:(NSString *)from
              session:(NIMSession *)session;

- (void)showRedPacketDetail:(NSString *)redPacketId;


#pragma mark - open url

- (void)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options;

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
