//
//  JXCustomAttachmentDecoder.m
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "JXCustomAttachmentDecoder.h"
#import "JXCustomAttachmentDefines.h"
#import "JXJanKenPonAttachment.h"
#import "JXSnapchatAttachment.h"
#import "JXChartletAttachment.h"
#import "JXWhiteboardAttachment.h"
#import "JXRedPacketAttachment.h"
#import "JXRedPacketTipAttachment.h"
#import "JXMultiRetweetAttachment.h"
#import "NSDictionary+DictionaryExt.h"
#import "JXSessionUtil.h"

@implementation JXCustomAttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;

    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:CMType];
            NSDictionary *data = [dict jsonDict:CMData];
            switch (type) {
                case CustomMessageTypeJanKenPon:
                {
                    attachment = [[JXJanKenPonAttachment alloc] init];
                    ((JXJanKenPonAttachment *)attachment).value = [data jsonInteger:CMValue];
                }
                    break;
                case CustomMessageTypeSnapchat:
                {
                    attachment = [[JXSnapchatAttachment alloc] init];
                    ((JXSnapchatAttachment *)attachment).md5 = [data jsonString:CMMD5];
                    ((JXSnapchatAttachment *)attachment).url = [data jsonString:CMURL];
                    ((JXSnapchatAttachment *)attachment).isFired = [data jsonBool:CMFIRE];
                }
                    break;
                case CustomMessageTypeChartlet:
                {
                    attachment = [[JXChartletAttachment alloc] init];
                    ((JXChartletAttachment *)attachment).chartletCatalog = [data jsonString:CMCatalog];
                    ((JXChartletAttachment *)attachment).chartletId      = [data jsonString:CMChartlet];
                }
                    break;
                case CustomMessageTypeWhiteboard:
                {
                    attachment = [[JXWhiteboardAttachment alloc] init];
                    ((JXWhiteboardAttachment *)attachment).flag = [data jsonInteger:CMFlag];
                }
                    break;
                case CustomMessageTypeRedPacket:
                {
                    attachment = [[JXRedPacketAttachment alloc] init];
                    ((JXRedPacketAttachment *)attachment).title = [data jsonString:CMRedPacketTitle];
                    ((JXRedPacketAttachment *)attachment).content = [data jsonString:CMRedPacketContent];
                    ((JXRedPacketAttachment *)attachment).redPacketId = [data jsonString:CMRedPacketId];
                }
                    break;
                case CustomMessageTypeRedPacketTip:
                {
                    attachment = [[JXRedPacketTipAttachment alloc] init];
                    ((JXRedPacketTipAttachment *)attachment).sendPacketId = [data jsonString:CMRedPacketSendId];
                    ((JXRedPacketTipAttachment *)attachment).packetId  = [data jsonString:CMRedPacketId];
                    ((JXRedPacketTipAttachment *)attachment).isGetDone = [data jsonString:CMRedPacketDone];
                    ((JXRedPacketTipAttachment *)attachment).openPacketId = [data jsonString:CMRedPacketOpenId];
                }
                    break;
                case CustomMessageTypeMultiRetweet:
                {
                    attachment = [[JXMultiRetweetAttachment alloc] init];
                    ((JXMultiRetweetAttachment *)attachment).url = [data jsonString:CMURL];
                    ((JXMultiRetweetAttachment *)attachment).md5 = [data jsonString:CMMD5];
                    ((JXMultiRetweetAttachment *)attachment).compressed = [data jsonBool:CMCompressed];
                    ((JXMultiRetweetAttachment *)attachment).encrypted = [data jsonBool:CMEncrypted];
                    ((JXMultiRetweetAttachment *)attachment).password = [data jsonString:CMPassword];
                    ((JXMultiRetweetAttachment *)attachment).messageAbstract = [data jsonArray:CMMessageAbstract];
                    ((JXMultiRetweetAttachment *)attachment).sessionName = [data jsonString:CMSessionName];
                    ((JXMultiRetweetAttachment *)attachment).sessionId = [data jsonString:CMSessionId];
                }
                    break;
                default:
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }
    }
    return attachment;
}


- (BOOL)checkAttachment:(id<NIMCustomAttachment>)attachment{
    BOOL check = NO;
    if ([attachment isKindOfClass:[JXJanKenPonAttachment class]])
    {
        NSInteger value = [((JXJanKenPonAttachment *)attachment) value];
        check = (value>=CustomJanKenPonValueKen && value<=CustomJanKenPonValuePon) ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JXSnapchatAttachment class]])
    {
        check = YES;
    }
    else if ([attachment isKindOfClass:[JXChartletAttachment class]])
    {
        NSString *chartletCatalog = ((JXChartletAttachment *)attachment).chartletCatalog;
        NSString *chartletId      =((JXChartletAttachment *)attachment).chartletId;
        check = chartletCatalog.length&&chartletId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[JXWhiteboardAttachment class]])
    {
        NSInteger flag = [((JXWhiteboardAttachment *)attachment) flag];
        check = ((flag >= CustomWhiteboardFlagInvite) && (flag <= CustomWhiteboardFlagClose)) ? YES : NO;
    }
    else if([attachment isKindOfClass:[JXRedPacketAttachment class]] || [attachment isKindOfClass:[JXRedPacketTipAttachment class]])
    {
        check = YES;
    }
    else if ([attachment isKindOfClass:[JXMultiRetweetAttachment class]])
    {
        JXMultiRetweetAttachment *target = (JXMultiRetweetAttachment *)attachment;
        if (target.url.length == 0 || target.messageAbstract.count == 0) {
            check = NO;
        } else if (target.encrypted && target.password.length == 0) {
            check = NO;
        } else {
            check = YES;
        }
    }
    return check;
}
@end
