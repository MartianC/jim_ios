//
//  JXSDKConfigDelegate.m
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXSDKConfigDelegate.h"
#import <NIMSDK/NIMSDK.h>
#import "JXBundleSetting.h"

@implementation JXSDKConfigDelegate

- (BOOL)shouldIgnoreNotification:(NIMNotificationObject *)notification
{
    BOOL ignore = NO;
    NIMNotificationContent *content = notification.content;
    if ([content isKindOfClass:[NIMTeamNotificationContent class]]) //这里做个示范如何忽略部分通知 (不在聊天界面显示)
    {
        NSArray *types = [[JXBundleSetting sharedConfig] ignoreTeamNotificationTypes];
        NIMTeamOperationType type = [(NIMTeamNotificationContent *)content operationType];
        for (NSString *item in types)
        {
            if (type == [item integerValue])
            {
                ignore = YES;
                break;
            }
        }
    }
    return ignore;
}

- (BOOL)shouldIgnoreMessage:(NIMMessage *)message
{
    NIMMessageType type = [JXBundleSetting sharedConfig].ignoreMessageType;
    if (message.messageType == type) {
        return YES;
    }
    return NO;
}

@end
