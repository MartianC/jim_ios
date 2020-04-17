//
//  NTESMessageUtil.m
//  NIM
//
//  Created by Netease on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JXMessageUtil.h"
#import "NIMMessageUtil.h"

@implementation JXMessageUtil

+ (NSString *)messageContent:(NIMMessage *)message {
    NSString *text = @"[未知消息]";
    if (message.messageType == NIMMessageTypeCustom) {
        text = [self customMessageContent:message];
    } else {
        text = [NIMMessageUtil messageContent:message];
    }
    return text;
}

+ (NSString *)customMessageContent:(NIMMessage *)message {
    NSString *text = @"[未知消息]";
    NIMCustomObject *object = message.messageObject;
    
    /*if ([object.attachment isKindOfClass:[NTESChartletAttachment class]])
    {
        text = @"[贴图]";
    }
    else if ([object.attachment isKindOfClass:[NTESRedPacketAttachment class]])
    {
        text = @"[红包消息]";
    }
    else if ([object.attachment isKindOfClass:[NTESRedPacketTipAttachment class]])
    {
        NTESRedPacketTipAttachment *attach = (NTESRedPacketTipAttachment *)object.attachment;
        text = attach.formatedMessage;
    }
    else if ([object.attachment isKindOfClass:[NTESMultiRetweetAttachment class]])
    {
        text = @"[聊天记录]";
    }
    else
    {
        text = @"[未知消息]";
    }*/
    return text;
}
@end
