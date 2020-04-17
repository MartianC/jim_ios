//
//  JXNotificationCenter.h
//

#import "JXService.h"
@class JXCustomNotificationDB;

extern NSString *JXCustomNotificationCountChanged;

@interface JXNotificationCenter : NSObject

+ (instancetype)sharedCenter;
- (void)start;

@end
