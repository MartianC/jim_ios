//
//  JXSessionCustomContentConfig.m
//

#import "JXSessionCustomContentConfig.h"
#import "JXCustomAttachmentDefines.h"

@interface JXSessionCustomContentConfig()

@end

@implementation JXSessionCustomContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<JXCustomAttachmentInfo> info = (id<JXCustomAttachmentInfo>)object.attachment;
    return [info contentSize:message cellWidth:cellWidth];
}

- (NSString *)cellContent:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<JXCustomAttachmentInfo> info = (id<JXCustomAttachmentInfo>)object.attachment;
    return [info cellContent:message];
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    NSAssert([object isKindOfClass:[NIMCustomObject class]], @"message must be custom");
    id<JXCustomAttachmentInfo> info = (id<JXCustomAttachmentInfo>)object.attachment;
    return [info contentViewInsets:message];
}


@end
