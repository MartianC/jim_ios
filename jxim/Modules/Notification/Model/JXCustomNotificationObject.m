//
//  JXCustomNotificationObject.m
//

#import "JXCustomNotificationObject.h"

@implementation JXCustomNotificationObject

- (instancetype)initWithNotification:(NIMCustomSystemNotification *)notification{
    self = [super init];
    if (self) {
        _sender    = notification.sender;
        _receiver  = notification.receiver;
        _timestamp = notification.timestamp;
        _content   = notification.content;
        _needBadge = notification.setting.shouldBeCounted;
    }
    return self;
}

@end
