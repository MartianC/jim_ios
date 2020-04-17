//
//  JXCustomNotificationDB.h
//

#import <Foundation/Foundation.h>
#import "JXService.h"

@class JXCustomNotificationObject;
@interface JXCustomNotificationDB : JXService

@property (nonatomic,assign) NSInteger unreadCount;

- (NSArray *)fetchNotifications:(JXCustomNotificationObject *)notification
                          limit:(NSInteger)limit;

- (BOOL)saveNotification:(JXCustomNotificationObject *)notification;

- (void)deleteNotification:(JXCustomNotificationObject *)notification;

- (void)deleteAllNotification;

- (void)markAllNotificationsAsRead;

@end
